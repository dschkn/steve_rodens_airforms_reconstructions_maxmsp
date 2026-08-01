#!/usr/bin/env python3
"""Render the trilingual Airforms project essay as a six-page A4 PDF."""

from __future__ import annotations

from pathlib import Path

from reportlab.lib.enums import TA_LEFT
from reportlab.lib.pagesizes import A4
from reportlab.lib.styles import ParagraphStyle
from reportlab.lib.utils import ImageReader
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont
from reportlab.pdfgen import canvas
from reportlab.platypus import Paragraph


ROOT = Path(__file__).resolve().parents[1]
OUTPUT = ROOT / "output" / "pdf" / "Airforms_Reconstruction_Description_EN-DE-RU.pdf"
SPECTRAL_MAP = ROOT / "analysis" / "airforms_full_recording_spectral_map.png"

PAGE_WIDTH, PAGE_HEIGHT = A4
LEFT = 48.0
RIGHT = 48.0
TOP = 49.0
BOTTOM = 48.0
CONTENT_WIDTH = PAGE_WIDTH - LEFT - RIGHT


def register_fonts() -> None:
    font_dir = Path("/usr/share/fonts/truetype/dejavu")
    pdfmetrics.registerFont(TTFont("DejaVu", str(font_dir / "DejaVuSans.ttf")))
    pdfmetrics.registerFont(TTFont("DejaVu-Bold", str(font_dir / "DejaVuSans-Bold.ttf")))
    pdfmetrics.registerFont(TTFont("DejaVu-Oblique", str(font_dir / "DejaVuSans.ttf")))


def styles() -> dict[str, ParagraphStyle]:
    return {
        "language": ParagraphStyle(
            "language", fontName="DejaVu-Bold", fontSize=8.0, leading=10.0,
            textColor="#1a1a1a", spaceAfter=12.0,
        ),
        "title": ParagraphStyle(
            "title", fontName="DejaVu-Bold", fontSize=20.0, leading=23.5,
            textColor="#111111", spaceAfter=4.0,
        ),
        "subtitle": ParagraphStyle(
            "subtitle", fontName="DejaVu-Oblique", fontSize=9.4, leading=12.0,
            textColor="#333333", spaceAfter=12.0,
        ),
        "heading": ParagraphStyle(
            "heading", fontName="DejaVu-Bold", fontSize=10.4, leading=12.5,
            textColor="#111111", spaceBefore=7.0, spaceAfter=3.2,
        ),
        "body": ParagraphStyle(
            "body", fontName="DejaVu", fontSize=8.35, leading=10.85,
            textColor="#181818", alignment=TA_LEFT, spaceAfter=4.5,
        ),
        "abstract": ParagraphStyle(
            "abstract", fontName="DejaVu", fontSize=8.45, leading=11.0,
            textColor="#181818", leftIndent=14.0, rightIndent=8.0, spaceAfter=4.5,
        ),
        "caption": ParagraphStyle(
            "caption", fontName="DejaVu", fontSize=6.55, leading=8.0,
            textColor="#333333", spaceBefore=2.5, spaceAfter=3.0,
        ),
        "small": ParagraphStyle(
            "small", fontName="DejaVu", fontSize=6.25, leading=7.8,
            textColor="#222222", spaceAfter=2.0,
        ),
        "inventory": ParagraphStyle(
            "inventory", fontName="DejaVu", fontSize=5.85, leading=7.2,
            textColor="#202020", leftIndent=0.0, firstLineIndent=0.0, spaceAfter=2.2,
        ),
    }


LANGUAGES = [
    {
        "label": "ENGLISH",
        "title": "From Plaster Breath to Probabilistic Spectra",
        "subtitle": "A compact Max/MSP reconstruction after Steve Roden's <i>Airforms</i>",
        "abstract_title": "Abstract",
        "abstract": (
            "This project reconstructs a way of moving rather than a physical installation. "
            "Two spectral fields brighten, overlap, thin out and return through unequal cycles, "
            "while noise behaves as a third porous body. Measurement is used not to fix the work "
            "as a transcription, but to form a probabilistic score: a machine whose breaths remain "
            "recognisable without repeating the source timeline."
        ),
        "material_title": "Air as material and method",
        "material": (
            "<i>Airforms</i> was first presented at the Scottsdale Museum of Contemporary Art in April 2004. "
            "Roden's point of departure was Wallace Neff's Airform architecture, in which concrete was "
            "sprayed over an inflated form. For the installation, five plaster shells were formed over "
            "small balloons and a speaker was placed inside each one. The sound source was transformed "
            "breath blown through an old wooden organ pipe. Air therefore acted as mould, excitation and "
            "slow temporal image. The 2005 LINE edition reorganised the five-channel work for stereo listening."
        ),
        "displacement_title": "The displacement",
        "displacement": (
            "The reconstruction gives up the plaster bodies and their room. Its question is narrower in "
            "material terms but wider in behaviour: which tendencies remain when sculpture is removed? "
            "A chord is treated as a population of partials whose members may arrive early, late or not "
            "at all. Form arises from recurrence and changing degrees of spectral visibility."
        ),
        "listening_title": "Listening, measuring, inferring",
        "listening": [
            (
                "The complete LINE_022 stereo recording lasts 56:14.29. It was used only as an external "
                "analytical source and is not included in the project. A mono sum at 22.05 kHz was measured "
                "with an 8192-point FFT, a 100 ms step and twelve logarithmic bands per octave from 40 Hz "
                "to 10 kHz. Here, a 'breath' means an inferred spectral swell, not a literal physiological "
                "inhalation or exhalation."
            ),
            (
                "The analysis finds 136 major crests. Crest-to-crest cycles have a median of 24.2 s "
                "(middle 50%: 23.6-25.9 s). Their order is structured: three classes centred near 23.58, "
                "24.19 and 25.99 s predominantly rotate short to medium to long and back to short. "
                "Correlation at a three-cycle lag is about 0.57; two rare dilations reach about 37 s."
            ),
            (
                "The result is stable across 64 detector settings: 136-137 crests and a 24.1-24.4 s median. "
                "Within each cycle, expansion normally lasts 9.5 s and contraction 14.8 s. The earlier "
                "77-second excerpt exposed this alternating phase scale, while the complete recording "
                "reveals the larger contour and its slow changes of density."
            ),
        ],
        "map_caption": (
            "Figure 1. Full-recording spectral map. Time runs horizontally and logarithmic frequency vertically. "
            "Small marks above the field denote inferred crests; lower marks denote intervening troughs."
        ),
        "score_title": "A probabilistic score in Max/MSP",
        "score": (
            "A JavaScript core schedules events but produces no audio. Three <font name='DejaVu'>poly~</font> "
            "banks with 24 <font name='DejaVu'>cycle~</font> voices realise spectra A, B and the quieter residue "
            "field C. Each breath chooses one of six crystallisation orders: low-to-high, high-to-low, "
            "centre-out, edges-in, constellation or scatter. A constellation begins with two to four "
            "isolated partials; depending on the event, only 2-6, 9-18 or all 24 lines may remain."
        ),
        "clocks_title": "Unequal clocks",
        "clocks": (
            "Banks A and B sample the measured short, medium and long transition model with small within-class "
            "variation. Approximately 1.5% of primary cycles dilate towards 37 s. Expansion and contraction "
            "are sampled separately; B begins about one expansion phase after A and then drifts. Density moves "
            "between targets lasting 10-22 cycles, or roughly four to nine minutes, so the model changes slowly "
            "without replaying the original eight measured sections."
        ),
        "orders": ["LOW TO HIGH", "HIGH TO LOW", "CONSTELLATION"],
        "orders_caption": (
            "Figure 2. Three activation orders. Dots mark the first appearance of a partial; the envelopes "
            "continue towards a shared crest and then contract on the longer side of the cycle."
        ),
        "inventory_title": "Frequency inventory used by the three banks (Hz)",
        "noise_title": "Noise as a third material",
        "noise": (
            "The noise layer is not a single undifferentiated <font name='DejaVu'>noise~</font>. Filtered breath "
            "follows the asymmetric primary cycle. Low rumble carries measured modulation regions near 5.5, "
            "8, 12.2 and 19 Hz; a moving radio-like band is modulated mostly between 0.6 and 5.8 Hz; short "
            "resonant dust events retain independent clocks. Weak A-by-B multiplication adds sum-and-difference "
            "energy only while the principal fields overlap."
        ),
        "conclusion_title": "Conclusion",
        "conclusion": (
            "The result is an analytical cast of behaviour. Loops become transition probabilities, chords "
            "become changing subsets, and room resonance becomes a deliberately synthetic residue. The patch "
            "does not replay one breath; it stages the conditions under which breathing may return."
        ),
        "sources_title": "Sources",
    },
    {
        "label": "DEUTSCH",
        "title": "Vom Gipsatem zum probabilistischen Spektrum",
        "subtitle": "Eine kompakte Max/MSP-Rekonstruktion nach Steve Rodens <i>Airforms</i>",
        "abstract_title": "Zusammenfassung",
        "abstract": (
            "Dieses Projekt rekonstruiert eine Bewegungsweise, nicht die physische Installation. Zwei "
            "spektrale Felder werden heller, überlagern sich, dünnen aus und kehren in ungleichen Zyklen "
            "zurück; Geräusch verhält sich wie ein dritter poröser Körper. Messung fixiert das Werk nicht "
            "als Transkription, sondern bildet eine probabilistische Partitur: eine Maschine, deren Atemzüge "
            "erkennbar bleiben, ohne den Zeitverlauf der Quelle zu wiederholen."
        ),
        "material_title": "Luft als Material und Verfahren",
        "material": (
            "<i>Airforms</i> wurde im April 2004 erstmals im Scottsdale Museum of Contemporary Art gezeigt. "
            "Ausgangspunkt war Wallace Neffs Airform-Architektur, bei der Beton über eine aufgeblasene Form "
            "gespritzt wurde. Für die Installation entstanden fünf Gipsschalen über kleinen Ballons; in jeder "
            "Schale befand sich ein Lautsprecher. Das Klangmaterial war transformierter Atem, der durch eine "
            "alte hölzerne Orgelpfeife geblasen wurde. Luft wirkte somit als Formkern, Anregung und langsames "
            "Zeitbild. Die LINE-Ausgabe von 2005 ordnete das fünfkanalige Werk für Stereo neu."
        ),
        "displacement_title": "Die Verschiebung",
        "displacement": (
            "Die Rekonstruktion verzichtet auf die Gipskörper und ihren Raum. Ihre Frage ist materiell enger, "
            "im Verhalten jedoch weiter: Welche Tendenzen bleiben, wenn die Skulptur entfällt? Ein Akkord gilt "
            "als Population von Teiltönen, deren Mitglieder früh, spät oder gar nicht erscheinen können. Form "
            "entsteht aus Wiederkehr und wechselnden Graden spektraler Sichtbarkeit."
        ),
        "listening_title": "Hören, messen, folgern",
        "listening": [
            (
                "Die vollständige Stereoaufnahme LINE_022 dauert 56:14,29. Sie diente nur als externe "
                "Analysequelle und ist nicht Teil des Projekts. Eine Monosumme mit 22,05 kHz wurde mit einer "
                "8192-Punkt-FFT, 100 ms Schrittweite und zwölf logarithmischen Bändern pro Oktave zwischen "
                "40 Hz und 10 kHz gemessen. 'Atem' bezeichnet hier eine erschlossene spektrale Welle, keinen "
                "wörtlich identifizierten physiologischen Vorgang."
            ),
            (
                "Die Analyse findet 136 große Gipfel. Vollständige Zyklen besitzen eine Medianlänge von 24,2 s "
                "(mittlere 50%: 23,6-25,9 s). Ihre Ordnung ist strukturiert: Drei Klassen um 23,58, 24,19 und "
                "25,99 s rotieren überwiegend kurz zu mittel zu lang und zurück zu kurz. Die Korrelation nach "
                "drei Zyklen beträgt etwa 0,57; zwei seltene Dehnungen reichen bis ungefähr 37 s."
            ),
            (
                "Das Ergebnis bleibt über 64 Detektoreinstellungen stabil: 136-137 Gipfel und ein Median von "
                "24,1-24,4 s. Innerhalb des Zyklus dauert die Expansion typischerweise 9,5 s, die Kontraktion "
                "14,8 s. Der frühere 77-Sekunden-Ausschnitt zeigte diese alternierende Phasengröße; erst die "
                "vollständige Aufnahme legt den größeren Kontur und die langsamen Dichteänderungen frei."
            ),
        ],
        "map_caption": (
            "Abbildung 1. Spektralkarte der vollständigen Aufnahme. Zeit verläuft horizontal, logarithmische "
            "Frequenz vertikal. Obere Marken bezeichnen erschlossene Gipfel, untere die dazwischenliegenden Täler."
        ),
        "score_title": "Eine probabilistische Partitur in Max/MSP",
        "score": (
            "Ein JavaScript-Kern plant Ereignisse, erzeugt aber selbst keinen Klang. Drei "
            "<font name='DejaVu'>poly~</font>-Bänke mit je 24 <font name='DejaVu'>cycle~</font>-Stimmen realisieren "
            "die Spektren A, B und das leisere Restfeld C. Jeder Atemzug wählt eine von sechs Ordnungen: "
            "tief-zu-hoch, hoch-zu-tief, Mitte-nach-außen, Ränder-nach-innen, Konstellation oder Streuung. "
            "Eine Konstellation beginnt mit zwei bis vier isolierten Teiltönen; aktiv bleiben 2-6, 9-18 oder alle 24 Linien."
        ),
        "clocks_title": "Ungleiche Uhren",
        "clocks": (
            "A und B verwenden das gemessene Übergangsmodell kurzer, mittlerer und langer Klassen mit kleiner "
            "Streuung innerhalb jeder Klasse. Ungefähr 1,5% der Hauptzyklen dehnen sich in Richtung 37 s. "
            "Expansion und Kontraktion werden getrennt gezogen; B beginnt etwa eine Expansionsphase nach A "
            "und driftet danach. Dichteziele halten 10-22 Zyklen, also etwa vier bis neun Minuten, sodass die "
            "Form sich langsam ändert, ohne die acht gemessenen Abschnitte nachzuspielen."
        ),
        "orders": ["TIEF ZU HOCH", "HOCH ZU TIEF", "KONSTELLATION"],
        "orders_caption": (
            "Abbildung 2. Drei Aktivierungsordnungen. Punkte markieren den ersten Einsatz eines Teiltons; die "
            "Hüllkurven laufen weiter zu einem gemeinsamen Gipfel und kontrahieren auf der längeren Zyklusseite."
        ),
        "inventory_title": "Frequenzinventar der drei Bänke (Hz)",
        "noise_title": "Geräusch als drittes Material",
        "noise": (
            "Die Geräuschschicht ist kein einzelnes undifferenziertes <font name='DejaVu'>noise~</font>. "
            "Gefilterter Atem folgt dem asymmetrischen Hauptzyklus. Tiefes Rumpeln trägt Modulationszonen um "
            "5,5, 8, 12,2 und 19 Hz; ein wanderndes radioähnliches Band wird meist zwischen 0,6 und 5,8 Hz "
            "moduliert; kurze resonante Staubereignisse behalten eigene Uhren. Eine schwache A-mal-B-" 
            "Multiplikation fügt nur während der Überlagerung Summen- und Differenzenergie hinzu."
        ),
        "conclusion_title": "Schluss",
        "conclusion": (
            "Das Ergebnis ist ein analytischer Abguss von Verhalten. Schleifen werden zu Übergangs-" 
            "wahrscheinlichkeiten, Akkorde zu wechselnden Teilmengen und Raumresonanz zu einem bewusst "
            "synthetischen Rest. Der Patch spielt keinen Atemzug nach; er inszeniert Bedingungen seiner Wiederkehr."
        ),
        "sources_title": "Quellen",
    },
    {
        "label": "РУССКИЙ",
        "title": "От гипсового дыхания к вероятностному спектру",
        "subtitle": "Компактная реконструкция <i>Airforms</i> Стива Родена в Max/MSP",
        "abstract_title": "Аннотация",
        "abstract": (
            "Этот проект реконструирует не физическую инсталляцию, а способ движения. Два спектральных "
            "поля высветляются, накладываются, редеют и возвращаются в неравных циклах, а шум ведет себя "
            "как третье пористое тело. Измерение не фиксирует работу в виде транскрипции, а формирует "
            "вероятностную партитуру: машину, чьи вдохи остаются узнаваемыми, не повторяя временную линию источника."
        ),
        "material_title": "Воздух как материал и метод",
        "material": (
            "<i>Airforms</i> впервые была показана в Scottsdale Museum of Contemporary Art в апреле 2004 года. "
            "Отправной точкой стала архитектура Airform Уоллеса Неффа: бетон напылялся поверх надутой формы. "
            "Для инсталляции Роден изготовил пять гипсовых оболочек на небольших воздушных шарах и поместил "
            "внутрь каждой динамик. Звуковым источником послужило преобразованное дыхание, пропущенное через "
            "старую деревянную органную трубу. Воздух действовал как форма, возбуждение звука и медленный образ "
            "времени. Издание LINE 2005 года реорганизовало пятиканальную работу для стерео."
        ),
        "displacement_title": "Смещение",
        "displacement": (
            "Реконструкция отказывается от гипсовых тел и помещения. Ее вопрос материально уже, но поведенчески "
            "шире: какие тенденции сохраняются после удаления скульптуры? Аккорд трактуется как популяция "
            "частичных, члены которой могут появиться раньше, позже или не появиться вовсе. Форма возникает "
            "из возвращений и меняющейся степени спектральной видимости."
        ),
        "listening_title": "Слушать, измерять, выводить",
        "listening": [
            (
                "Полная стереозапись LINE_022 длится 56:14,29. Она использовалась только как внешний источник "
                "анализа и не включена в проект. Монофоническая сумма 22,05 кГц измерялась через FFT 8192, с "
                "шагом 100 мс и двенадцатью логарифмическими полосами на октаву от 40 Гц до 10 кГц. 'Дыхание' "
                "здесь означает выведенную из спектра волну, а не буквально установленный физиологический вдох."
            ),
            (
                "Анализ выделяет 136 крупных гребней. Полные циклы имеют медиану 24,2 с (центральные 50%: "
                "23,6-25,9 с). Их порядок структурирован: три класса около 23,58, 24,19 и 25,99 с преимущественно "
                "вращаются короткий - средний - длинный - короткий. Корреляция через три цикла равна примерно "
                "0,57; два редких растяжения доходят приблизительно до 37 с."
            ),
            (
                "Результат устойчив в 64 настройках детектора: 136-137 гребней и медиана 24,1-24,4 с. Внутри "
                "цикла раскрытие обычно занимает 9,5 с, а сокращение 14,8 с. Прежний 77-секундный фрагмент "
                "показывал этот чередующийся масштаб фаз; полная запись раскрывает крупный контур и медленные "
                "изменения плотности."
            ),
        ],
        "map_caption": (
            "Рисунок 1. Спектральная карта полной записи. Время движется по горизонтали, логарифмическая частота "
            "по вертикали. Верхние метки обозначают выведенные гребни, нижние - промежуточные минимумы."
        ),
        "score_title": "Вероятностная партитура в Max/MSP",
        "score": (
            "Ядро JavaScript планирует события, но не создает звук. Три банка <font name='DejaVu'>poly~</font> "
            "по 24 голоса <font name='DejaVu'>cycle~</font> реализуют спектры A, B и более тихое остаточное поле C. "
            "Каждый вдох выбирает один из шести порядков кристаллизации: снизу вверх, сверху вниз, из центра, "
            "от краев, созвездие или рассеивание. Созвездие начинается с двух-четырех частичных; в событии "
            "могут остаться 2-6, 9-18 или все 24 линии."
        ),
        "clocks_title": "Неравные часы",
        "clocks": (
            "A и B используют измеренную модель переходов между коротким, средним и длинным классами с "
            "небольшим рассеянием внутри каждого. Примерно 1,5% основных циклов растягиваются к 37 с. Раскрытие "
            "и сокращение выбираются отдельно; B начинает примерно на одну фазу раскрытия позже A и затем "
            "дрейфует. Цели плотности сохраняются 10-22 цикла, то есть около четырех-девяти минут: форма "
            "меняется медленно, не воспроизводя восемь измеренных участков."
        ),
        "orders": ["СНИЗУ ВВЕРХ", "СВЕРХУ ВНИЗ", "СОЗВЕЗДИЕ"],
        "orders_caption": (
            "Рисунок 2. Три порядка активации. Точки отмечают первое появление частичной; огибающие продолжают "
            "двигаться к общему гребню и сокращаются на более длинной стороне цикла."
        ),
        "inventory_title": "Частотный состав трех банков (Гц)",
        "noise_title": "Шум как третий материал",
        "noise": (
            "Шумовой слой не сводится к одному недифференцированному <font name='DejaVu'>noise~</font>. "
            "Фильтрованное дыхание следует асимметричному основному циклу. Низкий гул несет зоны модуляции "
            "около 5,5, 8, 12,2 и 19 Гц; движущаяся радиопомеха модулируется преимущественно между 0,6 и "
            "5,8 Гц; короткие резонансные пылинки сохраняют отдельные часы. Слабое умножение A на B добавляет "
            "суммарно-разностную энергию только при перекрытии основных полей."
        ),
        "conclusion_title": "Заключение",
        "conclusion": (
            "Результат представляет собой аналитический слепок поведения. Лупы становятся вероятностями "
            "переходов, аккорды - меняющимися подмножествами, а резонанс комнаты - намеренно синтетическим "
            "остатком. Патч не воспроизводит один вдох; он создает условия, при которых дыхание может вернуться."
        ),
        "sources_title": "Источники",
    },
]


FREQUENCIES = {
    "A": (
        "63.033, 85.185, 94.346, 126.342, 183.496, 241.194, 296.601, 309.838, "
        "424.690, 480.097, 550.306, 604.573, 733.802, 846.907, 964.505, 1219.703, "
        "1417.709, 1516.304, 1660.675, 1770.009, 1856.011, 2439.406, 3422.401, 15723.265"
    ),
    "B": (
        "62.574, 94.336, 126.306, 183.461, 241.125, 296.552, 309.767, 424.586, "
        "537.677, 550.214, 629.678, 733.675, 840.503, 1001.296, 1023.019, 1219.705, "
        "1319.571, 1573.233, 2046.038, 3421.926, 5471.967, 7566.802, 8183.140, 8818.860"
    ),
    "C": (
        "40.800, 49.800, 55.180, 62.900, 70.660, 75.370, 80.080, 84.110, 94.200, "
        "104.970, 135.260, 189.760, 205.240, 212.640, 228.120, 257.050, 288.680, "
        "311.560, 349.910, 401.060, 566.590, 789.330, 838.450, 913.140"
    ),
}


SOURCES = [
    "Steve Roden / In Between Noise: https://www.inbetweennoise.com/discography/solo/airforms/",
    "LINE_022: https://www.lineimprint.com/editions/sound/line_022/",
    "Official 56:14 edition: https://lineimprint.bandcamp.com/album/airforms",
]


def draw_paragraph(c: canvas.Canvas, text: str, style: ParagraphStyle, y: float, width: float = CONTENT_WIDTH) -> float:
    paragraph = Paragraph(text, style)
    _, height = paragraph.wrap(width, PAGE_HEIGHT)
    paragraph.drawOn(c, LEFT, y - height)
    return y - height - style.spaceAfter


def draw_heading(c: canvas.Canvas, text: str, style: ParagraphStyle, y: float) -> float:
    y -= style.spaceBefore
    return draw_paragraph(c, text, style, y)


def draw_footer(c: canvas.Canvas, page_number: int) -> None:
    c.setStrokeColorRGB(0.78, 0.78, 0.78)
    c.setLineWidth(0.35)
    c.line(LEFT, 34.0, PAGE_WIDTH - RIGHT, 34.0)
    c.setFillColorRGB(0.18, 0.18, 0.18)
    c.setFont("DejaVu-Bold", 6.2)
    c.drawString(LEFT, 22.0, "AIRFORMS RECONSTRUCTION · MAX/MSP · © 2026 DMITRII SHCHUKIN")
    c.drawRightString(PAGE_WIDTH - RIGHT, 22.0, f"{page_number}/6")


def draw_activation_orders(c: canvas.Canvas, labels: list[str], y: float) -> float:
    box_width = (CONTENT_WIDTH - 22.0) / 3.0
    box_height = 54.0
    for panel in range(3):
        x0 = LEFT + panel * (box_width + 11.0)
        c.setFont("DejaVu-Bold", 6.3)
        c.setFillColorRGB(0.12, 0.12, 0.12)
        c.drawCentredString(x0 + box_width / 2.0, y - 8.0, labels[panel])
        baseline = y - 43.0
        c.setStrokeColorRGB(0.72, 0.72, 0.72)
        c.setLineWidth(0.35)
        c.line(x0 + 7.0, baseline, x0 + box_width - 7.0, baseline)
        for index in range(12):
            px = x0 + 8.0 + index * (box_width - 16.0) / 11.0
            if panel == 0:
                onset = index / 11.0
            elif panel == 1:
                onset = 1.0 - index / 11.0
            else:
                anchors = [2, 8, 5]
                onset = min(abs(index - anchor) for anchor in anchors) / 6.0
                if index in anchors:
                    onset = 0.0
            py = baseline + 5.0 + onset * 23.0
            c.setFillColorRGB(0.05, 0.05, 0.05)
            c.circle(px, py, 1.65, stroke=0, fill=1)
            c.setStrokeColorRGB(0.72, 0.72, 0.72)
            c.setLineWidth(0.25)
            c.line(px, baseline, px, py - 2.0)
    return y - box_height


def draw_page_one(c: canvas.Canvas, language: dict[str, object], page_number: int, sty: dict[str, ParagraphStyle]) -> None:
    y = PAGE_HEIGHT - TOP
    y = draw_paragraph(c, str(language["label"]), sty["language"], y)
    y = draw_paragraph(c, str(language["title"]), sty["title"], y)
    y = draw_paragraph(c, str(language["subtitle"]), sty["subtitle"], y)
    y = draw_heading(c, str(language["abstract_title"]), sty["heading"], y)
    y = draw_paragraph(c, str(language["abstract"]), sty["abstract"], y)
    y = draw_heading(c, str(language["material_title"]), sty["heading"], y)
    y = draw_paragraph(c, str(language["material"]), sty["body"], y)
    y = draw_heading(c, str(language["displacement_title"]), sty["heading"], y)
    y = draw_paragraph(c, str(language["displacement"]), sty["body"], y)
    y = draw_heading(c, str(language["listening_title"]), sty["heading"], y)
    for paragraph in language["listening"]:
        y = draw_paragraph(c, str(paragraph), sty["body"], y)

    image = ImageReader(str(SPECTRAL_MAP))
    image_width = CONTENT_WIDTH
    image_height = image_width * 622.0 / 2161.0
    y -= 2.0
    c.drawImage(image, LEFT, y - image_height, width=image_width, height=image_height, preserveAspectRatio=True, mask="auto")
    y -= image_height + 1.0
    y = draw_paragraph(c, str(language["map_caption"]), sty["caption"], y)
    if y < BOTTOM + 6.0:
        raise RuntimeError(f"Page {page_number} overflow: {y:.1f}")
    draw_footer(c, page_number)
    c.showPage()


def draw_page_two(c: canvas.Canvas, language: dict[str, object], page_number: int, sty: dict[str, ParagraphStyle]) -> None:
    y = PAGE_HEIGHT - TOP
    y = draw_paragraph(c, str(language["label"]), sty["language"], y)
    y = draw_heading(c, str(language["score_title"]), sty["heading"], y)
    y = draw_paragraph(c, str(language["score"]), sty["body"], y)
    y = draw_heading(c, str(language["clocks_title"]), sty["heading"], y)
    y = draw_paragraph(c, str(language["clocks"]), sty["body"], y)
    y -= 3.0
    y = draw_activation_orders(c, list(language["orders"]), y)
    y = draw_paragraph(c, str(language["orders_caption"]), sty["caption"], y)
    y = draw_heading(c, str(language["inventory_title"]), sty["heading"], y)
    for name in ("A", "B", "C"):
        y = draw_paragraph(c, f"<b>{name}</b>&nbsp;&nbsp;{FREQUENCIES[name]}", sty["inventory"], y)
    y = draw_heading(c, str(language["noise_title"]), sty["heading"], y)
    y = draw_paragraph(c, str(language["noise"]), sty["body"], y)
    y = draw_heading(c, str(language["conclusion_title"]), sty["heading"], y)
    y = draw_paragraph(c, str(language["conclusion"]), sty["body"], y)
    y = draw_heading(c, str(language["sources_title"]), sty["heading"], y)
    for source in SOURCES:
        y = draw_paragraph(c, source, sty["small"], y)
    if y < BOTTOM + 6.0:
        raise RuntimeError(f"Page {page_number} overflow: {y:.1f}")
    draw_footer(c, page_number)
    c.showPage()


def main() -> None:
    register_fonts()
    sty = styles()
    OUTPUT.parent.mkdir(parents=True, exist_ok=True)
    c = canvas.Canvas(str(OUTPUT), pagesize=A4, pageCompression=1)
    c.setTitle("From Plaster Breath to Probabilistic Spectra / Vom Gipsatem zum probabilistischen Spektrum / От гипсового дыхания к вероятностному спектру")
    c.setSubject("Trilingual project description for the Max/MSP reconstruction of Steve Roden's Airforms")
    c.setAuthor("Dmitrii Shchukin")
    c.setCreator("Dmitrii Shchukin")
    page_number = 1
    for language in LANGUAGES:
        draw_page_one(c, language, page_number, sty)
        page_number += 1
        draw_page_two(c, language, page_number, sty)
        page_number += 1
    c.save()
    print(OUTPUT)


if __name__ == "__main__":
    main()
