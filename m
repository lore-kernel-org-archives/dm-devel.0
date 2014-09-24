From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: Re: [PATCH] dm-raid: add RAID discard support
Date: Wed, 24 Sep 2014 13:02:28 +0200
Message-ID: <5422A4C4.4020707@redhat.com>
References: <1411491106-23676-1-git-send-email-heinzm@redhat.com>	<yq18ulaszpk.fsf@sermon.lab.mkp.net>	<20140924093308.120fe616@notabene.brown>	<yq1zjdpsqry.fsf@sermon.lab.mkp.net>	<7C39EB56-623A-4318-A558-258ABA32FF12@redhat.com>
	<20140924142157.33475baa@notabene.brown>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0430287654116088201=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20140924142157.33475baa@notabene.brown>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, Brassow Jonathan <jbrassow@redhat.com>
Cc: Shaohua Li <shli@kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--===============0430287654116088201==
Content-Type: multipart/alternative;
	boundary="------------060801040005010006090300"

This is a multi-part message in MIME format.
--------------060801040005010006090300
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit


Martin,

thanks for the good explanation of the state of the discard union.
Do you have an ETA for the 'zeroout, deallocate' ... support you mentioned?

I was planning to have a followup patch for dm-raid supporting a dm-raid 
table
line argument to prohibit discard passdown.

In lieu of the fuzzy field situation wrt SSD fw and discard_zeroes_data 
support
related to RAID4/5/6, we need that in upstream together with the initial 
patch.

That 'no_discard_passdown' table line can be added to dm-raid RAID4/5/6 
table
lines to avoid possible data corruption but can be avoided on RAID1/10 
table lines,
because the latter are not suffering from any  discard_zeroes_data flaw.


Neil,

are you going to disable discards in RAID4/5/6 shortly
or rather go with your bitmap solution?

Heinz


On 09/24/2014 06:21 AM, NeilBrown wrote:
> On Tue, 23 Sep 2014 23:05:51 -0500 Brassow Jonathan <jbrassow@redhat.com>
> wrote:
>
>> On Sep 23, 2014, at 9:20 PM, Martin K. Petersen wrote:
>>
>>>>>>>> "Neil" == NeilBrown  <neilb@suse.de> writes:
>>> Neil,
>>>
>>> Several people have pointed out the issues with the reliability of
>>> discard_zeroes_data in the past. My objection with Heinz' patch is
>>> purely that we are perpetuating an interface that we have come to learn
>>> that we can't entirely trust.
>>>
>>> Neil> If it is a "hint", then why isn't it
>>> Neil> "discard_sometimes_zeroes_data"?
>>>
>>> Because at the time we put it in it was expected to be a solid
>>> guarantee. However, as it turns out the spec is vaguely worded and only
>>> says that the device must return zeroes if a block has been successfully
>>> discarded. But since discard itself is only a hint the device is free to
>>> silently ignore all or parts of the request. *sigh*
>>>
>>> There were several approaches being entertained in both T10 and T13
>>> about how to tighten this up, including a FORCE bit that would cause the
>>> device to return an error if parts of the request were being ignored. I
>>> was hoping that we would be able to use that. However, the consensus at
>>> the T10 meeting this summer was that WRITE SAME is the only reliable way
>>> to ensure that zeroed blocks are returned. And the spec was amended to
>>> clarify that.
>>>
>>> Neil> If a read from a discarded region doesn't reliably return zeros,
>>> Neil> then raid5 cannot support discard.  Should I turn of discard
>>> Neil> support in raid5?
>>>
>>> I've been on the fence about this for a while.
>>>
>>> The good news is that while the spec has been vague and many battles
>>> fought in the standards bodies, most vendors are reasonably sane when it
>>> comes to implementing this. We haven't had any corruption horror stories
>>> from the field that I'm aware of. The first couple of generations of
>>> SSDs were a travesty in this department but current devices behave
>>> reasonably well. Hardware RAID vendors generally solve the RAID5 SSD
>>> problem by explicitly whitelisting drives that are known to do the right
>>> thing. Sadly we don't have a good device list. And for most drives the
>>> discards only get dropped in rare corner cases so it's not trivial to
>>> write a test tool to generate such a list.
>>>
>>> I was really hoping we'd get better guarantees from the standards folks
>>> this summer. But as the spec is currently written switching to a WRITE
>>> SAME bias in our discard heuristics may have the opposite effect of what
>>> we desire. That's because the spec mandates that if a device can not
>>> discard the blocks in the request it must write zeroes to them. IOW, we
>>> get the determinism at the expense of potentially ending up writing the
>>> blocks in question, thus increasing write wear. Probably not what we
>>> want for the discard use case.
>>>
>>> I am in the process of tweaking the discard code to adhere to the August
>>> 27th T10 SBC-4 draft. The net takeaway is that if you depend on reading
>>> zeroes back you should be using blkdev_issue_zeroout() and not
>>> blkdev_issue_discard(). raid5.c effectively needs to translate discard
>>> requests from above to zeroouts below.
>>>
>>> I am torn between making blkdev_issue_zeroout() unprovision if possible
>>> or having an explicit allocate flag. Some users only care about getting
>>> zeroes back but others use blkdev_issue_zeroout() to preallocate blocks
>>> (which is the current behavior).
>>>
>>> Right now we have:
>>>
>>>   discard		Unprovision, may or may not return zeroes
>>>   zeroout		Provision, return zeroes
>>>
>>> We'll have to move to a model where we have a third variant:
>>>
>>>   discard		Unprovision, may or may not return zeroes
>>>   zeroout, deallocate	Unprovision if possible, return zeroes
>>>   zeroout, allocate     Provision, return zeroes
>>>
>>> The zeroout, deallocate variant would be enabled if the device supports
>>> WRITE SAME w/UNMAP and has the LBPRZ flag set (and is not our libata
>>> SATL).
>>>
>>> Discard is the bane of my existence :(
> Thanks for the detailed explanation Martin!!
> It seems that "discard" still comes with a strong "Caveat Emptor"
> Sad.
>
>> It's not really so bad if it doesn't return zero's, is it?  As long as it returns the previous contents.  You mentioned that the discard was a hint - the drive may or may not discard the entire portion.  If that means the portions that are discarded will always return zero and the portions that aren't will always return their previous contents, is there any problem?  The real issue is randomness, no?  Could this be why "we haven't had any corruption horror stories", or is it because we got lucky with sane vendors?
> For RAID5 it is not acceptable to return "zeros or the original content".
> This is because of the possibility of RMW cycles to update the parity block.
> As "discard" the doesn't treat all blocks in a stripe in an identical way
> will cause the parity block to become incorrect, and it will stay incorrect
> through multiple RMW cycles until an RCW corrects it.
> A device failure while the parity block is incorrect will lead to data
> corruption.
>
> The only real solution I can think of is to maintain an 'allocated' bitmap
> and clear bits when DISCARDing.  When a write happens to a location that is
> not 'allocated' the whole  bit worth gets resynced (or maybe zeroed-out).
>
> Grumble.
>
> Thanks again,
> NeilBrown
>
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel

-- 
===============================================================
Heinz Mauelshagen                               +49 2626 141200
Consulting Development Engineer             FAX +49 2626 924446
Red Hat GmbH
Am Sonnenhang 11
56242 Marienrachdorf
Germany                                       heinzm@redhat.com
===============================================================


--------------060801040005010006090300
Content-Type: text/html; charset=windows-1252
Content-Transfer-Encoding: quoted-printable
X-MIME-Autoconverted: from 8bit to quoted-printable by mx5-phx2.redhat.com id s8OB2Ypf013398

<html>
  <head>
    <meta content=3D"text/html; charset=3Dwindows-1252"
      http-equiv=3D"Content-Type">
  </head>
  <body bgcolor=3D"#FFFFFF" text=3D"#000000">
    <br>
    Martin,<br>
    <br>
    thanks for the good explanation of the state of the discard union.<br=
>
    Do you have an ETA for the 'zeroout, deallocate' ... support you
    mentioned?<br>
    <br>
    I was planning to have a followup patch for dm-raid supporting a
    dm-raid table<br>
    line argument to prohibit discard passdown.<br>
    <br>
    In lieu of the fuzzy field situation wrt SSD fw and
    discard_zeroes_data support<br>
    related to RAID4/5/6, we need that in upstream together with the
    initial patch.<br>
    <br>
    That 'no_discard_passdown' table line can be added to dm-raid
    RAID4/5/6 table<br>
    lines to avoid possible data corruption but can be avoided on
    RAID1/10 table lines,<br>
    because the latter are not suffering from any=A0 discard_zeroes_data
    flaw.<br>
    <br>
    <br>
    Neil,<br>
    <br>
    are you going to disable discards in RAID4/5/6 shortly<br>
    or rather go with your bitmap solution?<br>
    <br>
    Heinz<br>
    <br>
    <br>
    <div class=3D"moz-cite-prefix">On 09/24/2014 06:21 AM, NeilBrown
      wrote:<br>
    </div>
    <blockquote cite=3D"mid:20140924142157.33475baa@notabene.brown"
      type=3D"cite">
      <pre wrap=3D"">On Tue, 23 Sep 2014 23:05:51 -0500 Brassow Jonathan =
<a class=3D"moz-txt-link-rfc2396E" href=3D"mailto:jbrassow@redhat.com">&l=
t;jbrassow@redhat.com&gt;</a>
wrote:

</pre>
      <blockquote type=3D"cite">
        <pre wrap=3D"">
On Sep 23, 2014, at 9:20 PM, Martin K. Petersen wrote:

</pre>
        <blockquote type=3D"cite">
          <blockquote type=3D"cite">
            <blockquote type=3D"cite">
              <blockquote type=3D"cite">
                <blockquote type=3D"cite">
                  <blockquote type=3D"cite">
                    <pre wrap=3D"">"Neil" =3D=3D NeilBrown  <a class=3D"m=
oz-txt-link-rfc2396E" href=3D"mailto:neilb@suse.de">&lt;neilb@suse.de&gt;=
</a> writes:
</pre>
                  </blockquote>
                </blockquote>
              </blockquote>
            </blockquote>
          </blockquote>
          <pre wrap=3D"">
Neil,

Several people have pointed out the issues with the reliability of
discard_zeroes_data in the past. My objection with Heinz' patch is
purely that we are perpetuating an interface that we have come to learn
that we can't entirely trust.

Neil&gt; If it is a "hint", then why isn't it
Neil&gt; "discard_sometimes_zeroes_data"?

Because at the time we put it in it was expected to be a solid
guarantee. However, as it turns out the spec is vaguely worded and only
says that the device must return zeroes if a block has been successfully
discarded. But since discard itself is only a hint the device is free to
silently ignore all or parts of the request. *sigh*

There were several approaches being entertained in both T10 and T13
about how to tighten this up, including a FORCE bit that would cause the
device to return an error if parts of the request were being ignored. I
was hoping that we would be able to use that. However, the consensus at
the T10 meeting this summer was that WRITE SAME is the only reliable way
to ensure that zeroed blocks are returned. And the spec was amended to
clarify that.

Neil&gt; If a read from a discarded region doesn't reliably return zeros,
Neil&gt; then raid5 cannot support discard.  Should I turn of discard
Neil&gt; support in raid5?

I've been on the fence about this for a while.

The good news is that while the spec has been vague and many battles
fought in the standards bodies, most vendors are reasonably sane when it
comes to implementing this. We haven't had any corruption horror stories
from the field that I'm aware of. The first couple of generations of
SSDs were a travesty in this department but current devices behave
reasonably well. Hardware RAID vendors generally solve the RAID5 SSD
problem by explicitly whitelisting drives that are known to do the right
thing. Sadly we don't have a good device list. And for most drives the
discards only get dropped in rare corner cases so it's not trivial to
write a test tool to generate such a list.

I was really hoping we'd get better guarantees from the standards folks
this summer. But as the spec is currently written switching to a WRITE
SAME bias in our discard heuristics may have the opposite effect of what
we desire. That's because the spec mandates that if a device can not
discard the blocks in the request it must write zeroes to them. IOW, we
get the determinism at the expense of potentially ending up writing the
blocks in question, thus increasing write wear. Probably not what we
want for the discard use case.

I am in the process of tweaking the discard code to adhere to the August
27th T10 SBC-4 draft. The net takeaway is that if you depend on reading
zeroes back you should be using blkdev_issue_zeroout() and not
blkdev_issue_discard(). raid5.c effectively needs to translate discard
requests from above to zeroouts below.

I am torn between making blkdev_issue_zeroout() unprovision if possible
or having an explicit allocate flag. Some users only care about getting
zeroes back but others use blkdev_issue_zeroout() to preallocate blocks
(which is the current behavior).

Right now we have:

 discard		Unprovision, may or may not return zeroes
 zeroout		Provision, return zeroes

We'll have to move to a model where we have a third variant:

 discard		Unprovision, may or may not return zeroes
 zeroout, deallocate	Unprovision if possible, return zeroes
 zeroout, allocate     Provision, return zeroes

The zeroout, deallocate variant would be enabled if the device supports
WRITE SAME w/UNMAP and has the LBPRZ flag set (and is not our libata
SATL).

Discard is the bane of my existence :(
</pre>
        </blockquote>
      </blockquote>
      <pre wrap=3D"">
Thanks for the detailed explanation Martin!!
It seems that "discard" still comes with a strong "Caveat Emptor"
Sad.

</pre>
      <blockquote type=3D"cite">
        <pre wrap=3D"">
It's not really so bad if it doesn't return zero's, is it?  As long as it=
 returns the previous contents.  You mentioned that the discard was a hin=
t - the drive may or may not discard the entire portion.  If that means t=
he portions that are discarded will always return zero and the portions t=
hat aren't will always return their previous contents, is there any probl=
em?  The real issue is randomness, no?  Could this be why "we haven't had=
 any corruption horror stories", or is it because we got lucky with sane =
vendors?
</pre>
      </blockquote>
      <pre wrap=3D"">
For RAID5 it is not acceptable to return "zeros or the original content".
This is because of the possibility of RMW cycles to update the parity blo=
ck.
As "discard" the doesn't treat all blocks in a stripe in an identical way
will cause the parity block to become incorrect, and it will stay incorre=
ct
through multiple RMW cycles until an RCW corrects it.
A device failure while the parity block is incorrect will lead to data
corruption.

The only real solution I can think of is to maintain an 'allocated' bitma=
p
and clear bits when DISCARDing.  When a write happens to a location that =
is
not 'allocated' the whole  bit worth gets resynced (or maybe zeroed-out).

Grumble.

Thanks again,
NeilBrown
</pre>
      <br>
      <fieldset class=3D"mimeAttachmentHeader"></fieldset>
      <br>
      <pre wrap=3D"">--
dm-devel mailing list
<a class=3D"moz-txt-link-abbreviated" href=3D"mailto:dm-devel@redhat.com"=
>dm-devel@redhat.com</a>
<a class=3D"moz-txt-link-freetext" href=3D"https://www.redhat.com/mailman=
/listinfo/dm-devel">https://www.redhat.com/mailman/listinfo/dm-devel</a><=
/pre>
    </blockquote>
    <br>
    <pre class=3D"moz-signature" cols=3D"72">--=20
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Heinz Mauelshagen                               +49 2626 141200
Consulting Development Engineer             FAX +49 2626 924446
Red Hat GmbH
Am Sonnenhang 11
56242 Marienrachdorf
Germany                                       <a class=3D"moz-txt-link-ab=
breviated" href=3D"mailto:heinzm@redhat.com">heinzm@redhat.com</a>
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D</pre>
  </body>
</html>

--------------060801040005010006090300--


--===============0430287654116088201==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 7bit


--===============0430287654116088201==--
