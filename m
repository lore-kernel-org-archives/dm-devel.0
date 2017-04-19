From: Markus Hentsch <markus.hentsch@cloudandheat.com>
Subject: Re: dm-era: metadata reuse after reboot possible?
Date: Wed, 19 Apr 2017 13:32:39 +0200
Message-ID: <8f623e41-9a70-9b09-41c0-de9f6e590fee@cloudandheat.com>
References: <c06844f1-bed2-7de3-5338-67f6a9d84f5a@cloudandheat.com>
	<20161031113749.GA27906@roamer.bos.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1140072336449796327=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20161031113749.GA27906@roamer.bos.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Edward Thornber <thornber@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--===============1140072336449796327==
Content-Type: multipart/alternative;
	boundary="------------E977E63F9142B385CF38951F"

This is a multi-part message in MIME format.
--------------E977E63F9142B385CF38951F
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

Hello, it's been a while. I've also been busy with other stuff in the
last months but now I'm back stuck at this issue. Has there been any
progress on this?

On Mo, Oct 31, 2016 at 12:37, Edward Thornber wrote:
> On Fri, Oct 21, 2016 at 11:29:26AM +0200, Markus Hentsch wrote:
>> Hello,
>>
>> is it possible for the dm-era metadata to survive reboots?
> No, you certainly should be able to continue using the metadata.  I
> don't have time to look at this for the next couple of weeks, but
> after that will definitely fix.
>
> - Joe

For reference, my original message from Fri, Oct 21, 2016 was:
> Hello,
>
> is it possible for the dm-era metadata to survive reboots?
>
> The official dm-era documentation states under "Resilience":
>
>     Metadata is updated on disk before a write to a previously unwritte=
n
>     block is performed.  As such dm-era should not be effected by a har=
d
>     crash such as power failure.
>
> That's why I initially assumed that I may continue (re)using the
> metadata after reboots without wiping it (i.e. resetting the eras and
> block tracking). But is that actually the case?
>
>
> Using a Ubuntu trusty x64 VM with 2 additional virtual HDDs (sdb and
> sdc, 256MB each), I set up dm-era after bootup like this:
>
>     root@alice:~# dmsetup create era-meta --table "0 256 linear /dev/sd=
b 0"
>     root@alice:~# dmsetup create era --table "0 524288 era /dev/mapper/=
era-meta /dev/sdc 4096"
>     root@alice:~# dmsetup create era-access --table "0 256 linear /dev/=
mapper/era-meta 0"
>
>
> When I reboot and repeat the commands above, the layout is recreated
> correctly (according to lsblk). However, taking a metadata snapshot
> and trying to access the metadata using era_dump or era_invalidate
> fails, e.g.:
>
>     root@alice:~# dmsetup message era 0 take_metadata_snap
>     root@alice:~# era_dump /dev/mapper/era-access
>     <superblock uuid=3D"" block_size=3D"4096" nr_blocks=3D"128" current=
_era=3D"3">
>     metadata contains errors (run era_check for details).
>     perhaps you wanted to run with --repair ?
>
>     root@alice:~# era_check /dev/mapper/era-access=20
>     examining superblock
>     missing eras from writeset tree
>       value size mismatch: expected 12, but got 8.  This is not the btr=
ee you are looking for.
>
>     era_check: /usr/include/boost/optional/optional.hpp:1004: boost::op=
tional<T>::reference_const_type
>       boost::optional<T>::get() const [with T =3D unsigned int; boost::=
optional<T>::reference_const_type =3D
>       const unsigned int&]: Assertion `this->is_initialized()' failed.
>     Aborted
>
>
> It doesn't matter if I take and drop any metadata snapshots or write
> to the era device before the reboot or not.
> Do I have to start over and wipe the metadata device directly after
> reboot or is there some way to continue using it, i.e. recovering its
> state when recreating the previous dmsetup layout?

Best regards,

Markus Hentsch
Cloud&Heat Technologies

--------------E977E63F9142B385CF38951F
Content-Type: text/html; charset=windows-1252
Content-Transfer-Encoding: 8bit

<html>
  <head>
    <meta content="text/html; charset=windows-1252"
      http-equiv="Content-Type">
  </head>
  <body bgcolor="#FFFFFF" text="#000000">
    Hello, it's been a while. I've also been busy with other stuff in
    the last months but now I'm back stuck at this issue. Has there been
    any progress on this?<br>
    <br>
    On Mo, Oct 31, 2016 at 12:37, Edward Thornber wrote:<br>
    <blockquote cite="mid:20161031113749.GA27906@roamer.bos.redhat.com"
      type="cite">
      <pre wrap="">On Fri, Oct 21, 2016 at 11:29:26AM +0200, Markus Hentsch wrote:
</pre>
      <blockquote type="cite">
        <pre wrap="">Hello,

is it possible for the dm-era metadata to survive reboots?
</pre>
      </blockquote>
      <pre wrap="">
No, you certainly should be able to continue using the metadata.  I
don't have time to look at this for the next couple of weeks, but
after that will definitely fix.

- Joe</pre>
    </blockquote>
    <pre wrap="">
</pre>
    For reference, my original message from Fri, Oct 21, 2016 was:<br>
    <blockquote type="cite">Hello,<br>
      <br>
      is it possible for the dm-era metadata to survive reboots?<br>
      <br>
      The official dm-era documentation states under "Resilience":<br>
      <blockquote>
        <pre>Metadata is updated on disk before a write to a previously unwritten
block is performed.  As such dm-era should not be effected by a hard
crash such as power failure.
</pre>
      </blockquote>
      That's why I initially assumed that I may continue (re)using the
      metadata after reboots without wiping it (i.e. resetting the eras
      and block tracking). But is that actually the case?<br>
      <br>
      <br>
      Using a Ubuntu trusty x64 VM with 2 additional virtual HDDs (<tt>sdb</tt>
      and <tt>sdc</tt>, 256MB each), I set up dm-era after bootup like
      this:<br>
      <blockquote>
        <pre>root@alice:~# dmsetup create era-meta --table "0 256 linear /dev/sdb 0"
root@alice:~# dmsetup create era --table "0 524288 era /dev/mapper/era-meta /dev/sdc 4096"
root@alice:~# dmsetup create era-access --table "0 256 linear /dev/mapper/era-meta 0"</pre>
      </blockquote>
      <br>
      When I reboot and repeat the commands above, the layout is
      recreated correctly (according to <tt>lsblk</tt>). However,
      taking a metadata snapshot and trying to access the metadata using
      <tt>era_dump</tt> or <tt>era_invalidate</tt> fails, e.g.:<br>
      <blockquote>
        <pre>root@alice:~# dmsetup message era 0 take_metadata_snap
root@alice:~# era_dump /dev/mapper/era-access
&lt;superblock uuid="" block_size="4096" nr_blocks="128" current_era="3"&gt;
metadata contains errors (run era_check for details).
perhaps you wanted to run with --repair ?

root@alice:~# era_check /dev/mapper/era-access 
examining superblock
missing eras from writeset tree
  value size mismatch: expected 12, but got 8.  This is not the btree you are looking for.

era_check: /usr/include/boost/optional/optional.hpp:1004: boost::optional&lt;T&gt;::reference_const_type
  boost::optional&lt;T&gt;::get() const [with T = unsigned int; boost::optional&lt;T&gt;::reference_const_type =
  const unsigned int&amp;]: Assertion `this-&gt;is_initialized()' failed.
Aborted
</pre>
      </blockquote>
      <br>
      It doesn't matter if I take and drop any metadata snapshots or
      write to the era device before the reboot or not.<br>
      Do I have to start over and wipe the metadata device directly
      after reboot or is there some way to continue using it, i.e.
      recovering its state when recreating the previous dmsetup layout?</blockquote>
    <br>
    Best regards,<br>
    <br>
    Markus Hentsch<br>
    Cloud&amp;Heat Technologies<br>
  </body>
</html>

--------------E977E63F9142B385CF38951F--


--===============1140072336449796327==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1140072336449796327==--
