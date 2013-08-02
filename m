From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: Fwd: Re: dm-cache with zero hit rate
Date: Fri, 02 Aug 2013 20:19:07 +0200
Message-ID: <51FBF81B.7090700@redhat.com>
References: <51FBF2FD.10205@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3180617671996304275=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <51FBF2FD.10205@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "dm-devel >> device-mapper development" <dm-devel@redhat.com>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--===============3180617671996304275==
Content-Type: multipart/alternative;
	boundary="------------040608070501040706020804"

This is a multi-part message in MIME format.
--------------040608070501040706020804
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit




-------- Original Message --------
Subject: 	Re: dm-cache with zero hit rate
Date: 	Fri, 02 Aug 2013 19:57:17 +0200
From: 	Heinz Mauelshagen <heinzm@redhat.com>
To: 	Steinar H. Gunderson <sgunderson@bigfoot.com>



On 08/02/2013 03:58 PM, Steinar H. Gunderson wrote:
> On Fri, Aug 02, 2013 at 09:23:44AM -0400, Mike Snitzer wrote:
>> Yes, it is surprising.  Curious to know if the promotions aren't
>> happening due to the IO scheduler somehow merging all your random small
>> IO.  We don't yet have a descrete counter to show the number of
>> migrations that were skipped due to sequential_threshold but that is
>> something we can add.
>>
>> But you can effectively disable the sequential_threshold by setting it
>> really high, e.g.:
>>
>> dmsetup message cache 0 sequential_threshold 16384
> I tried this, and it still doesn't appear to promote anything at all:
>
> cache: 0 23440891904 cache 913/8192 0 7021239 0 2049048 0 0 0 0 0 2 migration_threshold 2048 4 random_threshold 8 sequential_threshold 16384
>
> It's only been running for a few minutes, though.
>
> FWIW, earlier I ran it on only one single partition, and then it worked.
> So it's not like my kernel is completely broken, at least.

Doesn't seem so.

Because you succeeded on a partition, mind trying a small some GB mapping
with smaller block size too on top of your big RAID? Eventually apply
the config you
used for your to your partition and adjust that to your large RAID?

If that fails as well, it looks like some strange device specific issue
causing the failure.
If it succeeds, it seems to be a large size related one.

Heinz

>
>> Please write a file that is smaller than your specified
>> sequential_threshold, and then read it numerous times via direct IO,
>> e.g.:
>>
>> dd if=<your file> of=/dev/null iflag=direct bs=16K
> I did, with a 16 kB file (that should certainly be small enough, right?),
> executing the dd command 10000 times. Still nothing cached.
>
> /* Steinar */




--------------040608070501040706020804
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: 7bit

<html>
  <head>

    <meta http-equiv="content-type" content="text/html; charset=UTF-8">
  </head>
  <body text="#000000" bgcolor="#FFFFFF">
    <br>
    <div class="moz-forward-container"><br>
      <br>
      -------- Original Message --------
      <table class="moz-email-headers-table" border="0" cellpadding="0"
        cellspacing="0">
        <tbody>
          <tr>
            <th nowrap="nowrap" valign="BASELINE" align="RIGHT">Subject:
            </th>
            <td>Re: dm-cache with zero hit rate</td>
          </tr>
          <tr>
            <th nowrap="nowrap" valign="BASELINE" align="RIGHT">Date: </th>
            <td>Fri, 02 Aug 2013 19:57:17 +0200</td>
          </tr>
          <tr>
            <th nowrap="nowrap" valign="BASELINE" align="RIGHT">From: </th>
            <td>Heinz Mauelshagen <a class="moz-txt-link-rfc2396E" href="mailto:heinzm@redhat.com">&lt;heinzm@redhat.com&gt;</a></td>
          </tr>
          <tr>
            <th nowrap="nowrap" valign="BASELINE" align="RIGHT">To: </th>
            <td>Steinar H. Gunderson <a class="moz-txt-link-rfc2396E" href="mailto:sgunderson@bigfoot.com">&lt;sgunderson@bigfoot.com&gt;</a></td>
          </tr>
        </tbody>
      </table>
      <br>
      <br>
      <pre>On 08/02/2013 03:58 PM, Steinar H. Gunderson wrote:
&gt; On Fri, Aug 02, 2013 at 09:23:44AM -0400, Mike Snitzer wrote:
&gt;&gt; Yes, it is surprising.  Curious to know if the promotions aren't
&gt;&gt; happening due to the IO scheduler somehow merging all your random small
&gt;&gt; IO.  We don't yet have a descrete counter to show the number of
&gt;&gt; migrations that were skipped due to sequential_threshold but that is
&gt;&gt; something we can add.
&gt;&gt;
&gt;&gt; But you can effectively disable the sequential_threshold by setting it
&gt;&gt; really high, e.g.:
&gt;&gt;
&gt;&gt; dmsetup message cache 0 sequential_threshold 16384
&gt; I tried this, and it still doesn't appear to promote anything at all:
&gt;
&gt; cache: 0 23440891904 cache 913/8192 0 7021239 0 2049048 0 0 0 0 0 2 migration_threshold 2048 4 random_threshold 8 sequential_threshold 16384
&gt;
&gt; It's only been running for a few minutes, though.
&gt;
&gt; FWIW, earlier I ran it on only one single partition, and then it worked.
&gt; So it's not like my kernel is completely broken, at least.

Doesn't seem so.

Because you succeeded on a partition, mind trying a small some GB mapping
with smaller block size too on top of your big RAID? Eventually apply 
the config you
used for your to your partition and adjust that to your large RAID?

If that fails as well, it looks like some strange device specific issue 
causing the failure.
If it succeeds, it seems to be a large size related one.

Heinz

&gt;
&gt;&gt; Please write a file that is smaller than your specified
&gt;&gt; sequential_threshold, and then read it numerous times via direct IO,
&gt;&gt; e.g.:
&gt;&gt;
&gt;&gt; dd if=&lt;your file&gt; of=/dev/null iflag=direct bs=16K
&gt; I did, with a 16 kB file (that should certainly be small enough, right?),
&gt; executing the dd command 10000 times. Still nothing cached.
&gt;
&gt; /* Steinar */

</pre>
      <br>
    </div>
    <br>
  </body>
</html>

--------------040608070501040706020804--


--===============3180617671996304275==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============3180617671996304275==--
