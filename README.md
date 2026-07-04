# GreekDraCor
Ancient Greek drama. 45 plays in [TEI P5](https://tei-c.org/guidelines/p5/) format, adapted from the [Perseus Digital Library](https://github.com/PerseusDL), first converted to DraCor format in May 2019, rebooted in 2026. Licensed under [CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/). Menander’s comedy “Dyskolos” derived from Wikisource, licensed under [CC BY-SA 3.0](https://creativecommons.org/licenses/by-sa/3.0/).

The corpus is maintained by Julia Jennifer Beine (University of Würzburg) and Frank Fischer (Freie Universität Berlin).

**Update: This corpus is currently being completely rebooted in 2026, also adding the latest versions from the PDL.** 

Content: 7 plays by Aeschylus, 8 by Sophocles, 19 by Euripides, 11 by Aristophanes, 1 by Menander.

Betacode to Unicode conversion done with [betacode 0.2](https://pypi.org/project/betacode/).

## Scans of the editions on which the Perseus Digital Library team based their digitisation:

* Aeschylus. With an English translation by Herbert Weir Smyth. In two volumes. 
  * [Volume I. London: William Heinemann; New York: G. P. Putnam’s Sons 1922. (= The Loeb Classical Library 145).](https://archive.org/details/L145AeschylusISuppliantPersiansPrometheusSevenAgainstThebes/page/n2/)
    * Suppliant Maidens. Persians. Prometheus. Seven Against Thebes.
  * [Volume II. London: William Heinemann; New York: G. P. Putnam’s Sons 1926. (= The Loeb Classical Library 146).](https://archive.org/details/aeschyluswitheng02aescuoft/page/n8/)
    * Agamemnon. Libation-Bearers. Eumenides. <s>Fragments.</s>

* Sophocles. With an English translation by F. Storr. In two volumes. 
  * [Volume I. London: William Heinemann; New York: The Macmillan Co. 1912 (= The Loeb Classical Library 20).](https://archive.org/details/sophoclesstor01sophuoft/page/n8/)
    * Oedipus the King. Oedipus at Colonus. Antigone.
  * [Volume II. London: William Heinemann; New York: The Macmillan Co. 1913 (= The Loeb Classical Library 21).](https://archive.org/details/sophoclesstor02sophuoft/page/n8/)
    * Ajax. Electra. Trachiniae. Philoctetes.

* [The Oxyrhynchus Papyri. Part IX. Edited with Translations and Notes by Arthur S. Hunt. London: Egypt Exploration Fund 1912. Number 1174. pp. 30–86.](https://archive.org/details/pt9oxyrhynchuspa00grenuoft/page/30/)
  * Ichneutae.

* Euripidis Fabulae. Recognovit brevique adnotatione critica instruxit Gilbertus Murray.
  * [Tomus I. Oxford: Clarendon Press 1902 (= Scriptorum Classicorum Bibliotheca Oxoniensis).](https://archive.org/details/euripidisfabulae01euriuoft/page/n8/)
    * Cyclops. Alcestis. Medea. Heraclidae. Hippolytus. Andromacha. Hecuba.
  * [Tomus II. 3rd edition. Oxford: Clarendon Press 1913 (= Scriptorum Classicorum Bibliotheca Oxoniensis).](https://archive.org/details/euripidisfabu02euri/page/1/)
    * Supplices. Hercules. Ion. Troiades. Electra. Iphigenia Taurica.
  * [Tomus III. 2nd edition. Oxford: Clarendon Press 1913 (= Scriptorum Classicorum Bibliotheca Oxoniensis).](https://archive.org/details/euripidisfabulae03euri_0/page/n6/)
    * Helena. Phoenissae. Orestes. Bacchae. Iphigenia Aulidensis. Rhesus.

* Aristophanis Comoediae. Recognoverunt brevique adnotatione critica instruxerunt F. W. Hall et W. M. Geldart. 2 Tomi. 
  * [Tomus I. 2nd edition. Oxford: Clarendon Press 1906 (= Scriptorum Classicorum Bibliotheca Oxoniensis).](https://archive.org/details/aristophaniscomo01arisuoft/page/n8/)
    * Acharnenses. Equites. Nubes. Vespae. Pax. Aves.
  * [Tomus II. 2nd edition. Oxford: Clarendon Press [1907] (= Scriptorum Classicorum Bibliotheca Oxoniensis).](https://archive.org/details/aristophaniscomo02arisuoft/page/n8)
    * Lysistrata. Thesmophoriazusae. Ranae. Ecclesiazusae. Plutus. <s>Fragmenta.</s>

## Generate from Perseus Files

```sh
./perseus2dracor.sh
```
