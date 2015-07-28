From: Leonardo Santos <heiligerstein@gmail.com>
Subject: DMCache Desing Questions
Date: Tue, 28 Jul 2015 14:02:23 -0300
Message-ID: <CAEZ+n-j1GkLWN653xR7RO-N3KAS7L6x38Oyi6LTirwsDVH_2dQ@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6618632744954321367=="
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

--===============6618632744954321367==
Content-Type: multipart/alternative; boundary=089e0111c0a4148cbc051bf26fca

--089e0111c0a4148cbc051bf26fca
Content-Type: text/plain; charset=UTF-8

Hello,

Could anyone explain me about DMCache structure answering some questions?

1. How is metadata structure organized? B+ Tree from DM, so is it like
BCache?
2. What is the I/O path (i.e. when does lookup, policies and operation
modes act and in what order) ?
3. Is MQ completely based in paper from Yuanyuan Zhou et. al. "Second-Level
Buffer Cache Management" (except pre_cache (fifo) changed to MQ in DMCache)
or there is another change?
4. Is DMCache inspired by another DMCache implementation like "DMCache"
from Ming Zhao?

Thanks!
Leonardo Santos

--089e0111c0a4148cbc051bf26fca
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hello,<div><br></div><div>Could anyone explain me about DM=
Cache structure answering some questions?</div><div><br></div><div>1. How i=
s metadata structure organized? B+ Tree from DM, so is it like BCache?<br><=
/div><div>2. What is the I/O path (i.e. when does lookup, policies and oper=
ation modes act and in what order) ?<br></div><div>3. Is MQ completely base=
d in paper from Yuanyuan Zhou et. al. &quot;Second-Level Buffer Cache Manag=
ement&quot; (except pre_cache (fifo) changed to MQ in DMCache) or there is =
another change?</div><div>4. Is DMCache inspired by another DMCache impleme=
ntation like &quot;DMCache&quot; from Ming Zhao?</div><div><br></div><div>T=
hanks!</div><div>Leonardo Santos</div></div>

--089e0111c0a4148cbc051bf26fca--


--===============6618632744954321367==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============6618632744954321367==--
