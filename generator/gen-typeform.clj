(ns playsync.tmp4
  (:require [clojure.string :as str]
            [clojure.data.json :as json]))


(defonce output-filename "/Users/florinbraghis/code/Research/typeform-scheme/output.json")
(def input-filename "/Users/florinbraghis/code/Research/typeform-scheme/input-text.txt")


(defn parse-qa [qa]
  (let [split (str/split qa #"\n\?\n")]
    {:q (str/trim (first split))
     :a (str/trim (second split))}))

(defn parse-input-file [filename]
  (let [qa  (str/split (slurp filename) #"\n---\n")]
    (mapv parse-qa qa)))

(defn question-type [qtext]
  (let [text (str/trim qtext)]
    (if
      (nil? (re-matches #"^@ShortText\n*.*" text))
      "yes_no"
      "ShortText"
      )))


(defn parse-question [question]
  (let [v (str/split question #"\n")
        head-text (first v)
        rest-text (str/join "\n" (rest v))]
    {:question head-text
     :description rest-text}))

(defn parse-answer [answ]
  (parse-question answ))

(defn mk-yesno [item]
  (let [q (:q item)
        a (:a item)]
    [(into {:type (question-type q)} (parse-question q))
     (into {:type "statement"} (parse-answer a))]))

(defn do-controls []
  (let [qa (parse-input-file input-filename)]
    (flatten (mapv (fn [item] (mk-yesno item)) qa))))


(defn generate-form []
  {:title "The typeform schemer"
   :fields (do-controls)})

(defn generate-form-json [output-file]
  (spit output-file (json/write-str (generate-form))))

(generate-form-json output-filename)