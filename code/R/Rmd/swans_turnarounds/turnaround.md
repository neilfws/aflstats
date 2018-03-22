Sydney Swans/South Melbourne greatest (and worst) Q4 turnarounds
================
Neil Saunders
compiled 2018-03-22 17:32:09

-   [Introduction](#introduction)
-   [Getting the data](#getting-the-data)
-   [Analysis](#analysis)
    -   [Come from behind at Q3 to win](#come-from-behind-at-q3-to-win)
    -   [Slip from in front at Q3 to lose](#slip-from-in-front-at-q3-to-lose)

Introduction
============

How many times have the Swans come from behind going into the last quarter to win? Or been in front, but then gone on to lose? In each case, what were the biggest swings in the scoreline?

Getting the data
================

We download and process Swans game data from [AFL Tables](http://afltables.com).

There are currently 2407 of them.

Analysis
========

Come from behind at Q3 to win
-----------------------------

We select the subset of cases where the margin is negative at the end of Q3, but the result is a win. Then we sort by the difference between Q3 and Q4 margin.

The top 10:

<table style="width:99%;">
<colgroup>
<col width="30%" />
<col width="8%" />
<col width="9%" />
<col width="23%" />
<col width="15%" />
<col width="11%" />
</colgroup>
<thead>
<tr class="header">
<th align="center">date</th>
<th align="center">rnd</th>
<th align="center">type</th>
<th align="center">opponent</th>
<th align="center">q3margin</th>
<th align="center">margin</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="center">1995-04-30 14:15:00</td>
<td align="center">R5</td>
<td align="center">H</td>
<td align="center">Adelaide</td>
<td align="center">-17</td>
<td align="center">57</td>
</tr>
<tr class="even">
<td align="center">2002-08-10 19:10:00</td>
<td align="center">R19</td>
<td align="center">A</td>
<td align="center">Kangaroos</td>
<td align="center">-11</td>
<td align="center">47</td>
</tr>
<tr class="odd">
<td align="center">1915-06-12 15:00:00</td>
<td align="center">R8</td>
<td align="center">H</td>
<td align="center">Geelong</td>
<td align="center">-29</td>
<td align="center">18</td>
</tr>
<tr class="even">
<td align="center">2015-04-04 16:35:00</td>
<td align="center">R1</td>
<td align="center">H</td>
<td align="center">Essendon</td>
<td align="center">-34</td>
<td align="center">12</td>
</tr>
<tr class="odd">
<td align="center">1987-04-25 14:10:00</td>
<td align="center">R5</td>
<td align="center">A</td>
<td align="center">Richmond</td>
<td align="center">-26</td>
<td align="center">20</td>
</tr>
<tr class="even">
<td align="center">1990-08-17 19:40:00</td>
<td align="center">R20</td>
<td align="center">H</td>
<td align="center">Brisbane Bears</td>
<td align="center">-14</td>
<td align="center">31</td>
</tr>
<tr class="odd">
<td align="center">1933-05-06 14:45:00</td>
<td align="center">R2</td>
<td align="center">H</td>
<td align="center">Footscray</td>
<td align="center">-19</td>
<td align="center">26</td>
</tr>
<tr class="even">
<td align="center">1926-07-17 14:45:00</td>
<td align="center">R12</td>
<td align="center">A</td>
<td align="center">Richmond</td>
<td align="center">-12</td>
<td align="center">33</td>
</tr>
<tr class="odd">
<td align="center">2003-04-25 18:45:00</td>
<td align="center">R5</td>
<td align="center">H</td>
<td align="center">Melbourne</td>
<td align="center">-20</td>
<td align="center">24</td>
</tr>
<tr class="even">
<td align="center">1958-07-19 14:15:00</td>
<td align="center">R13</td>
<td align="center">H</td>
<td align="center">Fitzroy</td>
<td align="center">-12</td>
<td align="center">32</td>
</tr>
<tr class="odd">
<td align="center">1933-09-16 14:30:00</td>
<td align="center">SF</td>
<td align="center">F</td>
<td align="center">Richmond</td>
<td align="center">-26</td>
<td align="center">18</td>
</tr>
</tbody>
</table>

They've come from behind in Q3 to win 175 times.

Slip from in front at Q3 to lose
--------------------------------

The procedure is very similar, except that we select the cases where margin is positive at the end of Q3, but the result is a loss.

<table>
<colgroup>
<col width="30%" />
<col width="8%" />
<col width="9%" />
<col width="25%" />
<col width="15%" />
<col width="11%" />
</colgroup>
<thead>
<tr class="header">
<th align="center">date</th>
<th align="center">rnd</th>
<th align="center">type</th>
<th align="center">opponent</th>
<th align="center">q3margin</th>
<th align="center">margin</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="center">1936-07-25 14:45:00</td>
<td align="center">R12</td>
<td align="center">A</td>
<td align="center">Melbourne</td>
<td align="center">12</td>
<td align="center">-52</td>
</tr>
<tr class="even">
<td align="center">1938-05-14 14:45:00</td>
<td align="center">R4</td>
<td align="center">A</td>
<td align="center">Melbourne</td>
<td align="center">11</td>
<td align="center">-52</td>
</tr>
<tr class="odd">
<td align="center">1991-04-25 14:10:00</td>
<td align="center">R6</td>
<td align="center">A</td>
<td align="center">North Melbourne</td>
<td align="center">2</td>
<td align="center">-54</td>
</tr>
<tr class="even">
<td align="center">1962-07-21 14:20:00</td>
<td align="center">R13</td>
<td align="center">H</td>
<td align="center">St Kilda</td>
<td align="center">36</td>
<td align="center">-17</td>
</tr>
<tr class="odd">
<td align="center">1991-04-19 19:40:00</td>
<td align="center">R5</td>
<td align="center">H</td>
<td align="center">Essendon</td>
<td align="center">21</td>
<td align="center">-31</td>
</tr>
<tr class="even">
<td align="center">1978-04-22 14:10:00</td>
<td align="center">R4</td>
<td align="center">A</td>
<td align="center">Fitzroy</td>
<td align="center">32</td>
<td align="center">-19</td>
</tr>
<tr class="odd">
<td align="center">1992-07-25 14:10:00</td>
<td align="center">R19</td>
<td align="center">A</td>
<td align="center">Footscray</td>
<td align="center">2</td>
<td align="center">-46</td>
</tr>
<tr class="even">
<td align="center">1957-05-18 14:15:00</td>
<td align="center">R5</td>
<td align="center">H</td>
<td align="center">Essendon</td>
<td align="center">5</td>
<td align="center">-42</td>
</tr>
<tr class="odd">
<td align="center">2004-08-07 19:10:00</td>
<td align="center">R19</td>
<td align="center">H</td>
<td align="center">Kangaroos</td>
<td align="center">40</td>
<td align="center">-6</td>
</tr>
<tr class="even">
<td align="center">1937-06-05 14:30:00</td>
<td align="center">R7</td>
<td align="center">A</td>
<td align="center">Essendon</td>
<td align="center">12</td>
<td align="center">-32</td>
</tr>
</tbody>
</table>

They've thrown it away in the last quarter 157 times.
