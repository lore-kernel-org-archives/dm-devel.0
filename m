From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: Re: [PATCH] dm-raid: add RAID discard support
Date: Wed, 01 Oct 2014 13:13:10 +0200
Message-ID: <542BE1C6.2050105@redhat.com>
References: <1411491106-23676-1-git-send-email-heinzm@redhat.com>	<yq18ulaszpk.fsf@sermon.lab.mkp.net>	<20140924093308.120fe616@notabene.brown>	<yq1zjdpsqry.fsf@sermon.lab.mkp.net>	<7C39EB56-623A-4318-A558-258ABA32FF12@redhat.com>	<20140924142157.33475baa@notabene.brown>	<5422A4C4.4020707@redhat.com>
	<20141001125625.1e0d356a@notabene.brown>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0848240246708864161=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20141001125625.1e0d356a@notabene.brown>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Shaohua Li <shli@kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--===============0848240246708864161==
Content-Type: multipart/alternative;
	boundary="------------020608020103020502030403"

This is a multi-part message in MIME format.
--------------020608020103020502030403
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit

On 10/01/2014 04:56 AM, NeilBrown wrote:
> On Wed, 24 Sep 2014 13:02:28 +0200 Heinz Mauelshagen <heinzm@redhat.com>
> wrote:
>
>> Martin,
>>
>> thanks for the good explanation of the state of the discard union.
>> Do you have an ETA for the 'zeroout, deallocate' ... support you mentioned?
>>
>> I was planning to have a followup patch for dm-raid supporting a dm-raid
>> table
>> line argument to prohibit discard passdown.
>>
>> In lieu of the fuzzy field situation wrt SSD fw and discard_zeroes_data
>> support
>> related to RAID4/5/6, we need that in upstream together with the initial
>> patch.
>>
>> That 'no_discard_passdown' table line can be added to dm-raid RAID4/5/6
>> table
>> lines to avoid possible data corruption but can be avoided on RAID1/10
>> table lines,
>> because the latter are not suffering from any  discard_zeroes_data flaw.
>>
>>
>> Neil,
>>
>> are you going to disable discards in RAID4/5/6 shortly
>> or rather go with your bitmap solution?
> Can I just close my eyes and hope it goes away?

I'd think that it actually would.

Sane deployments are unlikely to base MD RAID4/5/6 mappings on 
ancient/unreliable SSDs.
Your "md_mod.willing_to_risk_discard=Y" mentioned below is the proper
way against all insane odds.

BTW:
we're referring to SSD discard_zeroes_data issues only so far it seems?
Can we be sure that SCSI unmap with the TPRZ bit set will always return
zeroes on reads for arbitrary storage devices?

>
> The idea of a bitmap of uninitialised areas is not a short-term solution.
> But I'm not really keen on simply disabling discard for RAID4/5/6 either. It
> would  mean that people with good sensible hardware wouldn't be able to use
> it properly.
>
> I would really rather that discard_zeroes_data were only set on devices where
> it was actually true.  Then it wouldn't be my problem any more.
>
> Maybe I could do a loud warning
>    "Not enabling DISCARD on RAID5 because we cannot trust committees.
>     Set "md_mod.willing_to_risk_discard=Y" if your devices reads discarded
>     sectors as zeros"

Yes, we are thinking the same for dm-raid (like a "force_discard" 
parameter).

>
> and add an appropriate module parameter......
>
> While we are on the topic, maybe I should write down my thoughts about the
> bitmap thing in case someone wants to contribute.
>
>    There are 3 states that a 'region' can be in:
>      1- known to be in-sync
>      2- possibly not in sync, but it should  be
>      3- probably not in sync, contains no valuable data.
>
>   A read from '3' should return zeroes.
>   A write to '3' should change the region to be '2'.  It could either
>      write zeros before allowing the write to start, or it could just start
>      a normal resync.
>
>   Here is a question:  if a region has been discarded, are we guaranteed that
>   reads are at least stable.  i.e. if I read twice will I definitely get the
>   same value?

We can never be sure taking the standards and implementation hassle
into account.
Thus RAID system OEMs have whitelists for supported drives.

>
>   It would be simplest to store all the states in the one bitmap. i.e. have a
>   new version of the current bitmap (which distinguishes between '1' and '2')
>   which allows the 3rd state.  Probably just 2 bits per region, though we could
>   squeeze state for 20 regions into 32 bits if we really wanted :-)
>
>   Then we set the bitmap to all '3's when it is created and set regions to
>   '3' when discarding.
>
>   One problem with this approach is that it forces the same region size.
>   Regions for the current bitmap can conveniently be 10s of Megabytes.  For
>   state '3', we ideally want one region per stripe.
>   For 4TB drives with a 512K chunk size (and smaller is not uncommon) that is
>   8 million regions which is a megabyte of bits.
>
>   I guess that isn't all that much.  One problem with small regions for the
>   1/2 distinction is that we end up updating the bitmap more often, but
>   that could be avoided by setting multiple bits at one.
>   i.e. keep the internal counters with a larger granularity, and when a
>   counter (of outstanding writes) becomes non-zero, set quite a few bits in
>   the bitmap.

How close can you get with update patterns on bitmaps for that new approach
to what we have with the current one?
Will it be negligible or performance impacting?


>
>   So that is probably what I would do:
>    - new version for bitmap which has 2 bits per region and encodes 3 states
>    - bitmap granularity matches chunk size (by default)
>    - decouple region size of bitmap from region size for internal 'dirty'
>      accounting
>    - write to a 'state 3' region sets it to 'state 2' and kicks off resync
>    - 'discard' sets state to '3'.

Makes sense but we'd rather avoid it based on the aforementioned 
"willing" option.

Heinz

>
> NeilBrown
>
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel


--------------020608020103020502030403
Content-Type: text/html; charset=windows-1252
Content-Transfer-Encoding: 7bit

<html>
  <head>
    <meta content="text/html; charset=windows-1252"
      http-equiv="Content-Type">
  </head>
  <body bgcolor="#FFFFFF" text="#000000">
    On 10/01/2014 04:56 AM, NeilBrown wrote:<br>
    <blockquote cite="mid:20141001125625.1e0d356a@notabene.brown"
      type="cite">
      <pre wrap="">On Wed, 24 Sep 2014 13:02:28 +0200 Heinz Mauelshagen <a class="moz-txt-link-rfc2396E" href="mailto:heinzm@redhat.com">&lt;heinzm@redhat.com&gt;</a>
wrote:

</pre>
      <blockquote type="cite">
        <pre wrap="">
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
</pre>
      </blockquote>
      <pre wrap="">
Can I just close my eyes and hope it goes away?</pre>
    </blockquote>
    <br>
    I'd think that it actually would.<br>
    <br>
    Sane deployments are unlikely to base MD RAID4/5/6 mappings on
    ancient/unreliable SSDs.<br>
    Your "md_mod.willing_to_risk_discard=Y" mentioned below is the
    proper<br>
    way against all insane odds.<br>
    <br>
    BTW:<br>
    we're referring to SSD discard_zeroes_data issues only so far it
    seems?<br>
    Can we be sure that SCSI unmap with the TPRZ bit set will always
    return<br>
    zeroes on reads for arbitrary storage devices?<br>
    <br>
    <blockquote cite="mid:20141001125625.1e0d356a@notabene.brown"
      type="cite">
      <pre wrap="">

The idea of a bitmap of uninitialised areas is not a short-term solution.
But I'm not really keen on simply disabling discard for RAID4/5/6 either. It
would  mean that people with good sensible hardware wouldn't be able to use
it properly.

I would really rather that discard_zeroes_data were only set on devices where
it was actually true.  Then it wouldn't be my problem any more.

Maybe I could do a loud warning
  "Not enabling DISCARD on RAID5 because we cannot trust committees.
   Set "md_mod.willing_to_risk_discard=Y" if your devices reads discarded
   sectors as zeros"</pre>
    </blockquote>
    <br>
    Yes, we are thinking the same for dm-raid (like a "force_discard"
    parameter).<br>
    <br>
    <blockquote cite="mid:20141001125625.1e0d356a@notabene.brown"
      type="cite">
      <pre wrap="">

and add an appropriate module parameter......

While we are on the topic, maybe I should write down my thoughts about the
bitmap thing in case someone wants to contribute.

  There are 3 states that a 'region' can be in:
    1- known to be in-sync
    2- possibly not in sync, but it should  be
    3- probably not in sync, contains no valuable data.

 A read from '3' should return zeroes.
 A write to '3' should change the region to be '2'.  It could either
    write zeros before allowing the write to start, or it could just start
    a normal resync.

 Here is a question:  if a region has been discarded, are we guaranteed that
 reads are at least stable.  i.e. if I read twice will I definitely get the
 same value?</pre>
    </blockquote>
    <br>
    We can never be sure taking the standards and implementation hassle<br>
    into account.<br>
    Thus RAID system OEMs have whitelists for supported drives.<br>
    <br>
    <blockquote cite="mid:20141001125625.1e0d356a@notabene.brown"
      type="cite">
      <pre wrap="">

 It would be simplest to store all the states in the one bitmap. i.e. have a
 new version of the current bitmap (which distinguishes between '1' and '2')
 which allows the 3rd state.  Probably just 2 bits per region, though we could
 squeeze state for 20 regions into 32 bits if we really wanted :-)

 Then we set the bitmap to all '3's when it is created and set regions to
 '3' when discarding.

 One problem with this approach is that it forces the same region size.
 Regions for the current bitmap can conveniently be 10s of Megabytes.  For
 state '3', we ideally want one region per stripe.
 For 4TB drives with a 512K chunk size (and smaller is not uncommon) that is
 8 million regions which is a megabyte of bits.

 I guess that isn't all that much.  One problem with small regions for the
 1/2 distinction is that we end up updating the bitmap more often, but
 that could be avoided by setting multiple bits at one.
 i.e. keep the internal counters with a larger granularity, and when a
 counter (of outstanding writes) becomes non-zero, set quite a few bits in
 the bitmap.</pre>
    </blockquote>
    <br>
    How close can you get with update patterns on bitmaps for that new
    approach<br>
    to what we have with the current one?<br>
    Will it be negligible or performance impacting?<br>
    <br>
    <br>
    <blockquote cite="mid:20141001125625.1e0d356a@notabene.brown"
      type="cite">
      <pre wrap="">

 So that is probably what I would do:
  - new version for bitmap which has 2 bits per region and encodes 3 states
  - bitmap granularity matches chunk size (by default)
  - decouple region size of bitmap from region size for internal 'dirty'
    accounting
  - write to a 'state 3' region sets it to 'state 2' and kicks off resync
  - 'discard' sets state to '3'.</pre>
    </blockquote>
    <br>
    Makes sense but we'd rather avoid it based on the aforementioned
    "willing" option.<br>
    <br>
    Heinz<br>
    <br>
    <blockquote cite="mid:20141001125625.1e0d356a@notabene.brown"
      type="cite">
      <pre wrap="">

NeilBrown
</pre>
      <br>
      <fieldset class="mimeAttachmentHeader"></fieldset>
      <br>
      <pre wrap="">--
dm-devel mailing list
<a class="moz-txt-link-abbreviated" href="mailto:dm-devel@redhat.com">dm-devel@redhat.com</a>
<a class="moz-txt-link-freetext" href="https://www.redhat.com/mailman/listinfo/dm-devel">https://www.redhat.com/mailman/listinfo/dm-devel</a></pre>
    </blockquote>
    <br>
  </body>
</html>

--------------020608020103020502030403--


--===============0848240246708864161==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0848240246708864161==--
