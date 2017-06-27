From: Eric Ren <zren@suse.com>
Subject: Re: dm mirror: fix crash caused by NULL-pointer
 dereference
Date: Tue, 27 Jun 2017 09:46:50 +0800
Message-ID: <9eeefac3-9aa3-386b-bb53-f701de2bb93b@suse.com>
References: <20170626090848.21585-1-zren@suse.com>
	<7ba503ae-ab87-493a-264c-3b42f8418c34@redhat.com>
	<3291473d-1eec-89a7-c3a1-d49c82df500c@suse.com>
	<a2d51150-c820-57b8-f1d1-c39c7576929b@suse.com>
	<20170626143723.GA31713@redhat.com>
	<a2dcb2e0-cba2-6776-f041-605a66486ec5@suse.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4644060773413242688=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <a2dcb2e0-cba2-6776-f041-605a66486ec5@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: jtang@suse.com, dm-devel@redhat.com, neilb@suse.com, agk@redhat.com, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--===============4644060773413242688==
Content-Type: multipart/alternative;
	boundary="------------FA938A8D471DFAB4C81C9684"

This is a multi-part message in MIME format.
--------------FA938A8D471DFAB4C81C9684
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

On 06/26/2017 11:27 PM, Eric Ren wrote:
> Hi Mike,
>
>
> On 06/26/2017 10:37 PM, Mike Snitzer wrote:
>> On Mon, Jun 26 2017 at  9:47am -0400,
>> Eric Ren <zren@suse.com> wrote:
>> [...snip...]
>>>> """
>>>> Revert "dm mirror: use all available legs on multiple failures"
>>>> dm io: fix duplicate bio completion due to missing ref count
>>> I have a confusion about this "dm io..." fix. The fix itself is good.
>>>
>>> Without it, a mkfs.ext4 on a mirrored dev whose primary mirror dev
>>> has failed, will crash the kernel with the discard operation from 
>>> mkfs.ext4.
>>> However, mkfs.ext4 can succeed on a healthy mirrored device. This
>>> is the thing I don't understand, because no matter the mirrored 
>>> device is
>>> good or not, there's always a duplicate bio completion before having 
>>> this
>>> this fix, thus write_callback() will be called twice, crashing will
>>> occur on the
>>> second write_callback():
>> No, there is only a duplicate bio completion if the error path is taken
>> (e.g. underlying device doesn't support discard).
> Hmm, when "op == REQ_OP_DISCARD", please see comments in do_region():
>
> """
> static void do_region(int op, int op_flags, unsigned region,
>                       struct dm_io_region *where, struct dpages *dp,
>                       struct io *io)
> {
> ...
>  if (op == REQ_OP_DISCARD)
>                 special_cmd_max_sectors = q->limits.max_discard_sectors;
> ...
>         if ((op == REQ_OP_DISCARD || op == REQ_OP_WRITE_ZEROES ||
>              op == REQ_OP_WRITE_SAME) && special_cmd_max_sectors == 0) {
>                 atomic_inc(&io->count);        ===> [1]
>                 dec_count(io, region, -EOPNOTSUPP);     ===> [2]
>                 return;
>         }
> """
>
> [1] ref count fixed by patch "dm io: ...";
> [2] we won't come here if "special_cmd_max_sectors != 0", which is 
> true when both sides
> of the mirror is good.
>
> So only when a mirror device fails, "max_discard_sectors" on its queue 
> is 0, thus this error path
> will be taken, right?

Yes, I checked this as below:

- print info
"""
@@ -310,8 +310,10 @@ static void do_region(int op, int op_flags, 
unsigned region,
         /*
          * Reject unsupported discard and write same requests.
          */
-       if (op == REQ_OP_DISCARD)
+       if (op == REQ_OP_DISCARD) {
special_cmd_max_sectors = q->limits.max_discard_sectors;
+ DMERR("do_region: op=DISCARD, q->limits.max_discard_sectors=%d\n", 
special_cmd_max_sectors);
+       }
"""
- log message when mkfs on mirror device that primary leg fails:
[ 169.672880] device-mapper: io: do_region: op=DISCARD, 
q->limits.max_discard_sectors=0    ===> for the failed leg
[ 169.672885] device-mapper: io: do_region: op=DISCARD, 
q->limits.max_discard_sectors=8388607   ===> for the good leg

Thanks,
Eric
>
>>
>>> """
>>> static void write_callback(unsigned long error, void *context)
>>> {
>>>          unsigned i;
>>>          struct bio *bio = (struct bio *) context;
>>>          struct mirror_set *ms;
>>>          int should_wake = 0;
>>>          unsigned long flags;
>>>
>>>          ms = bio_get_m(bio)->ms;        ====> NULL pointer at the
>>> duplicate completion
>>>          bio_set_m(bio, NULL);
>>> """
>>>
>>> If no this fix, I expected the DISCARD IO would always crash the
>>> kernel, but it's not true when
>>> the mirrored device is good. Hope someone happen to know the reason
>>> can give some hints ;-P
>> If the mirror is healthy then only one completion is returned to
>> dm-mirror (via write_callback).  The problem was the error patch wasn't
>> managing the reference count as needed.  Whereas dm-io's normal discard
>> IO path does.
>
> Yes, I can understand this.
>
> Thanks a lot,
> Eric
>
>>
>> Mike
>>
>> -- 
>> dm-devel mailing list
>> dm-devel@redhat.com
>> https://www.redhat.com/mailman/listinfo/dm-devel
>>
>
> -- 
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel


--------------FA938A8D471DFAB4C81C9684
Content-Type: text/html; charset=windows-1252
Content-Transfer-Encoding: 8bit

<html>
  <head>
    <meta content="text/html; charset=windows-1252"
      http-equiv="Content-Type">
  </head>
  <body bgcolor="#FFFFFF" text="#000000">
    <p>Hi,<br>
    </p>
    <div class="moz-cite-prefix">On 06/26/2017 11:27 PM, Eric Ren wrote:<br>
    </div>
    <blockquote cite="mid:a2dcb2e0-cba2-6776-f041-605a66486ec5@suse.com"
      type="cite">Hi Mike,
      <br>
      <br>
      <br>
      On 06/26/2017 10:37 PM, Mike Snitzer wrote:
      <br>
      <blockquote type="cite">On Mon, Jun 26 2017 at  9:47am -0400,
        <br>
        Eric Ren <a class="moz-txt-link-rfc2396E" href="mailto:zren@suse.com">&lt;zren@suse.com&gt;</a> wrote:
        <br>
        [...snip...]
        <br>
        <blockquote type="cite">
          <blockquote type="cite">"""
            <br>
            Revert "dm mirror: use all available legs on multiple
            failures"
            <br>
            dm io: fix duplicate bio completion due to missing ref count
            <br>
          </blockquote>
          I have a confusion about this "dm io..." fix. The fix itself
          is good.
          <br>
          <br>
          Without it, a mkfs.ext4 on a mirrored dev whose primary mirror
          dev
          <br>
          has failed, will crash the kernel with the discard operation
          from mkfs.ext4.
          <br>
          However, mkfs.ext4 can succeed on a healthy mirrored device.
          This
          <br>
          is the thing I don't understand, because no matter the
          mirrored device is
          <br>
          good or not, there's always a duplicate bio completion before
          having this
          <br>
          this fix, thus write_callback() will be called twice, crashing
          will
          <br>
          occur on the
          <br>
          second write_callback():
          <br>
        </blockquote>
        No, there is only a duplicate bio completion if the error path
        is taken
        <br>
        (e.g. underlying device doesn't support discard).
        <br>
      </blockquote>
      Hmm, when "op == REQ_OP_DISCARD", please see comments in
      do_region():
      <br>
      <br>
      """
      <br>
      static void do_region(int op, int op_flags, unsigned region,
      <br>
                            struct dm_io_region *where, struct dpages
      *dp,
      <br>
                            struct io *io)
      <br>
      {
      <br>
      ...
      <br>
       if (op == REQ_OP_DISCARD)
      <br>
                      special_cmd_max_sectors =
      q-&gt;limits.max_discard_sectors;
      <br>
      ...
      <br>
              if ((op == REQ_OP_DISCARD || op == REQ_OP_WRITE_ZEROES ||
      <br>
                   op == REQ_OP_WRITE_SAME) &amp;&amp;
      special_cmd_max_sectors == 0) {
      <br>
                      atomic_inc(&amp;io-&gt;count);        ===&gt;  
      [1]
      <br>
                      dec_count(io, region, -EOPNOTSUPP);     ===&gt; 
      [2]
      <br>
                      return;
      <br>
              }
      <br>
      """
      <br>
      <br>
      [1] ref count fixed by patch "dm io: ...";
      <br>
      [2] we won't come here if "special_cmd_max_sectors != 0", which is
      true when both sides
      <br>
      of the mirror is good.
      <br>
      <br>
      So only when a mirror device fails, "max_discard_sectors" on its
      queue is 0, thus this error path
      <br>
      will be taken, right?
      <br>
    </blockquote>
    <br>
    Yes, I checked this as below:<br>
    <br>
    - print info<br>
    """<br>
    <div id="magicdomid251" class="ace-line"><span
        class="author-a-z67zz71zqnz84z9mz78zkoz72znz65zuyq">@@ -310,8
        +310,10 @@ static void do_region(int op, int op_flags, unsigned
        region,</span></div>
    <div id="magicdomid252" class="ace-line"><span
        class="author-a-z67zz71zqnz84z9mz78zkoz72znz65zuyq">        /*</span></div>
    <div id="magicdomid253" class="ace-line"><span
        class="author-a-z67zz71zqnz84z9mz78zkoz72znz65zuyq">         *
        Reject unsupported discard and write same requests.</span></div>
    <div id="magicdomid254" class="ace-line"><span
        class="author-a-z67zz71zqnz84z9mz78zkoz72znz65zuyq">         */</span></div>
    <div id="magicdomid255" class="ace-line"><span
        class="author-a-z67zz71zqnz84z9mz78zkoz72znz65zuyq">-       if
        (op == REQ_OP_DISCARD)</span></div>
    <div id="magicdomid256" class="ace-line"><span
        class="author-a-z67zz71zqnz84z9mz78zkoz72znz65zuyq">+       if
        (op == REQ_OP_DISCARD) {</span></div>
    <div id="magicdomid257" class="ace-line"><span
        class="author-a-z67zz71zqnz84z9mz78zkoz72znz65zuyq">               
        special_cmd_max_sectors = q-&gt;limits.max_discard_sectors;</span></div>
    <div id="magicdomid258" class="ace-line"><span
        class="author-a-z67zz71zqnz84z9mz78zkoz72znz65zuyq">+              
        DMERR("do_region: op=DISCARD,
        q-&gt;limits.max_discard_sectors=%d\n",
        special_cmd_max_sectors);</span></div>
    <div id="magicdomid259" class="ace-line"><span
        class="author-a-z67zz71zqnz84z9mz78zkoz72znz65zuyq">+       }</span></div>
    """<br>
    - log message when mkfs on mirror device that primary leg fails:<br>
    <span class="author-a-z67zz71zqnz84z9mz78zkoz72znz65zuyq">[
      169.672880] device-mapper: io: do_region: op=DISCARD,
      q-&gt;limits.max_discard_sectors=0    ===&gt; for the failed leg</span><br>
    <span class="author-a-z67zz71zqnz84z9mz78zkoz72znz65zuyq">[ 
      169.672885] device-mapper: io: do_region: op=DISCARD,
      q-&gt;limits.max_discard_sectors=8388607   ===&gt; for the good
      leg<br>
      <br>
      Thanks,<br>
      Eric<br>
    </span>
    <blockquote cite="mid:a2dcb2e0-cba2-6776-f041-605a66486ec5@suse.com"
      type="cite">
      <br>
      <blockquote type="cite">
        <br>
        <blockquote type="cite">"""
          <br>
          static void write_callback(unsigned long error, void *context)
          <br>
          {
          <br>
                   unsigned i;
          <br>
                   struct bio *bio = (struct bio *) context;
          <br>
                   struct mirror_set *ms;
          <br>
                   int should_wake = 0;
          <br>
                   unsigned long flags;
          <br>
          <br>
                   ms = bio_get_m(bio)-&gt;ms;        ====&gt; NULL
          pointer at the
          <br>
          duplicate completion
          <br>
                   bio_set_m(bio, NULL);
          <br>
          """
          <br>
          <br>
          If no this fix, I expected the DISCARD IO would always crash
          the
          <br>
          kernel, but it's not true when
          <br>
          the mirrored device is good. Hope someone happen to know the
          reason
          <br>
          can give some hints ;-P
          <br>
        </blockquote>
        If the mirror is healthy then only one completion is returned to
        <br>
        dm-mirror (via write_callback).  The problem was the error patch
        wasn't
        <br>
        managing the reference count as needed.  Whereas dm-io's normal
        discard
        <br>
        IO path does.
        <br>
      </blockquote>
      <br>
      Yes, I can understand this.
      <br>
      <br>
      Thanks a lot,
      <br>
      Eric
      <br>
      <br>
      <blockquote type="cite">
        <br>
        Mike
        <br>
        <br>
        --
        <br>
        dm-devel mailing list
        <br>
        <a class="moz-txt-link-abbreviated" href="mailto:dm-devel@redhat.com">dm-devel@redhat.com</a>
        <br>
        <a class="moz-txt-link-freetext" href="https://www.redhat.com/mailman/listinfo/dm-devel">https://www.redhat.com/mailman/listinfo/dm-devel</a>
        <br>
        <br>
      </blockquote>
      <br>
      --
      <br>
      dm-devel mailing list
      <br>
      <a class="moz-txt-link-abbreviated" href="mailto:dm-devel@redhat.com">dm-devel@redhat.com</a>
      <br>
      <a class="moz-txt-link-freetext" href="https://www.redhat.com/mailman/listinfo/dm-devel">https://www.redhat.com/mailman/listinfo/dm-devel</a>
      <br>
    </blockquote>
    <br>
  </body>
</html>

--------------FA938A8D471DFAB4C81C9684--


--===============4644060773413242688==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============4644060773413242688==--
