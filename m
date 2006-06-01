From: Dwaine Garden <dwainegarden@rogers.com>
Subject: Re: Re: [PATCH] dm-striped device sizes must be multiple
	of chunk-size
Date: Thu, 1 Jun 2006 03:18:24 -0700 (PDT)
Message-ID: <20060601101824.90967.qmail@web88209.mail.re2.yahoo.com>
References: <447C452B.4030401@free.fr>
Reply-To: Dwaine Garden <dwainegarden@rogers.com>,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0392969277=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <447C452B.4030401@free.fr>
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

--===============0392969277==
Content-Type: multipart/alternative; boundary="0-2008427053-1149157104=:86745"

--0-2008427053-1149157104=:86745
Content-Type: text/plain; charset=us-ascii

There is a new rpm for dmraid that you can install that will resolve your issue.   rc11.

----- Original Message ----
From: Peyrotau Yannick <peyrotau.yannick@free.fr>
To: dm-devel@redhat.com
Sent: Tuesday, May 30, 2006 9:14:19 AM
Subject: [dm-devel] Re: [PATCH] dm-striped device sizes must be multiple of chunk-size

Hi, I have the same problem too when i try to upgrade to 2.6.16 kernel.

My motherbord is ASUS A8N-E with a nvidia raid chip.

I have make an archive with my metadata at this adress :
http://crashteam1.free.fr/metadata/metadata_isw-Yannick_Peyrotau-raid0.tar.bz2

Can i resolve it ?


Thanks,
Yannick

 > Dwaine,
 >
 > can you please send me your metadata for refernence as well so
 > that I can confirm that my fix is good for bz #186842 ?
 >
 > Thanks,
 > Heinz
 >
 > On Sun, Mar 26, 2006 at 12:01:17AM +0000, Dwaine Garden wrote:
 > > Kevin Corry <kevcorry <at> us.ibm.com> writes:
 > > >
 > > > I'm thinking that this mapping would do what the BIOS is actually
 > > > intending.
 > > > It ought to be relatively straight-forward to recognize this
 > > > situation in
 > > > dmraid and set up a mapping similar to the one above.
 > > >
 > >
 > > I have the same problem.  How would you resolve this?
 > >
 > > Dwaine
 > >
 > >
 > >
 > >
 > > --
 > > dm-devel mailing list
 > > dm-devel redhat com
 > > https://www.redhat.com/mailman/listinfo/dm-devel

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel




--0-2008427053-1149157104=:86745
Content-Type: text/html; charset=us-ascii

<html><head><style type="text/css"><!-- DIV {margin:0px} --></style></head><body><div style="font-family:times new roman, new york, times, serif;font-size:12pt"><div style="font-family: times new roman,new york,times,serif; font-size: 12pt;"><div>There is a new rpm for dmraid that you can install that will resolve your issue.&nbsp;&nbsp; rc11.<br><br>----- Original Message ----<br>From: Peyrotau Yannick &lt;peyrotau.yannick@free.fr&gt;<br>To: dm-devel@redhat.com<br>Sent: Tuesday, May 30, 2006 9:14:19 AM<br>Subject: [dm-devel] Re: [PATCH] dm-striped device sizes must be multiple of chunk-size<br><br><div>Hi, I have the same problem too when i try to upgrade to 2.6.16 kernel.<br><br>My motherbord is ASUS A8N-E with a nvidia raid chip.<br><br>I have make an archive with my metadata at this adress :<br><a target="_blank"
 href="http://crashteam1.free.fr/metadata/metadata_isw-Yannick_Peyrotau-raid0.tar.bz2">http://crashteam1.free.fr/metadata/metadata_isw-Yannick_Peyrotau-raid0.tar.bz2</a><br><br>Can i resolve it ?<br><br><br>Thanks,<br>Yannick<br><br> &gt; Dwaine,<br> &gt;<br> &gt; can you please send me your metadata for refernence as well so<br> &gt; that I can confirm that my fix is good for bz #186842 ?<br> &gt;<br> &gt; Thanks,<br> &gt; Heinz<br> &gt;<br> &gt; On Sun, Mar 26, 2006 at 12:01:17AM +0000, Dwaine Garden wrote:<br> &gt; &gt; Kevin Corry &lt;kevcorry &lt;at&gt; us.ibm.com&gt; writes:<br> &gt; &gt; &gt;<br> &gt; &gt; &gt; I'm thinking that this mapping would do what the BIOS is actually<br> &gt; &gt; &gt; intending.<br> &gt; &gt; &gt; It ought to be relatively straight-forward to recognize this<br> &gt; &gt; &gt; situation in<br> &gt; &gt; &gt; dmraid and set up a mapping similar to the one 
 above.<br> &gt; &gt; &gt;<br> &gt; &gt;<br> &gt; &gt; I have the same
 problem.&nbsp;&nbsp;How would you resolve this?<br> &gt; &gt;<br> &gt; &gt; Dwaine<br> &gt; &gt;<br> &gt; &gt;<br> &gt; &gt;<br> &gt; &gt;<br> &gt; &gt; --<br> &gt; &gt; dm-devel mailing list<br> &gt; &gt; dm-devel redhat com<br> &gt; &gt; <a target="_blank" href="https://www.redhat.com/mailman/listinfo/dm-devel">https://www.redhat.com/mailman/listinfo/dm-devel</a><br><br>--<br>dm-devel mailing list<br>dm-devel@redhat.com<br><a target="_blank" href="https://www.redhat.com/mailman/listinfo/dm-devel">https://www.redhat.com/mailman/listinfo/dm-devel</a><br></div></div></div></div></body></html>
--0-2008427053-1149157104=:86745--


--===============0392969277==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0392969277==--
