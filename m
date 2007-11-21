From: "Stefan Bader" <Stefan.Bader@de.ibm.com>
Subject: Re: order of preference / multipath.conf
Date: Wed, 21 Nov 2007 17:48:01 +0100
Message-ID: <5201e28f0711210848m7ff4f2daxb6644b2ae006a3e7@mail.gmail.com>
References: <940B4FF1F5958E4F96FC83C055A2F2611B8C9D@exch-2003.incipient.waltham>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0607920926=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <940B4FF1F5958E4F96FC83C055A2F2611B8C9D@exch-2003.incipient.waltham>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============0607920926==
Content-Type: multipart/alternative;
	boundary="----=_Part_25985_395751.1195663681044"

------=_Part_25985_395751.1195663681044
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

2007/11/21, Paul Cote <paul.cote@incipient.com>:
>
>
>
> I found this in an old thread and want to confirm as it will influence
> how/what we include in multipath.conf
>
>
>
> Is the following order of preference accurate?
>
>
>
> 1) Multipaths section (in /etc/multipath.conf)
>
> 2) Device section   (in /etc/multipath.conf)
>
> 3) Defaults section (in /etc/multipath.conf)
>
> 4) Internal default (hwtable.c)
>
>
>
> The last two (3 and 4) are the other way round. If there is an entry in
hwtable.c, this will take effect.

Stefan

------=_Part_25985_395751.1195663681044
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<br><br><div><span class="gmail_quote">2007/11/21, Paul Cote &lt;<a href="mailto:paul.cote@incipient.com">paul.cote@incipient.com</a>&gt;:</span><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">










<div link="blue" vlink="purple" lang="EN-US">

<div>

<p><font face="Arial" size="2"><span style="font-size: 10pt; font-family: Arial;">&nbsp;</span></font></p>

<p><font face="Arial" size="2"><span style="font-size: 10pt; font-family: Arial;">I found this in an old thread and want to confirm as it will
influence how/what we include in multipath.conf</span></font></p>

<p><font face="Arial" size="2"><span style="font-size: 10pt; font-family: Arial;">&nbsp;</span></font></p>

<p><font face="Arial" size="2"><span style="font-size: 10pt; font-family: Arial;">Is the following order of preference accurate? </span></font></p>

<pre><font face="Arial" size="2"><span style="font-size: 10pt; font-family: Arial;">&nbsp;</span></font></pre><pre><font face="Arial" size="2"><span style="font-size: 10pt; font-family: Arial;">1) Multipaths section (in /etc/multipath.conf)
</span></font></pre><pre><font face="Arial" size="2"><span style="font-size: 10pt; font-family: Arial;">2) Device section&nbsp;&nbsp; (in /etc/multipath.conf)</span></font></pre><pre><font face="Arial" size="2"><span style="font-size: 10pt; font-family: Arial;">
3) Defaults section (in /etc/multipath.conf)</span></font></pre><pre><font face="Arial" size="2"><span style="font-size: 10pt; font-family: Arial;">4) Internal default (hwtable.c)</span></font></pre><pre><font face="Arial" size="2">
<span style="font-size: 10pt; font-family: Arial;">&nbsp;</span></font></pre></div></div></blockquote></div>The last two (3 and 4) are the other way round. If there is an entry in hwtable.c, this will take effect.<br><br>Stefan
<br>

------=_Part_25985_395751.1195663681044--


--===============0607920926==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0607920926==--
