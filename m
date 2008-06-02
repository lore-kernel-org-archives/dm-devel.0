From: Yan Li <elliot.li.tech@gmail.com>
Subject: Re: 2.6.24 Kernel Soft Lock Up with heavy I/O in dm-crypt
Date: Mon, 2 Jun 2008 11:07:38 +0800
Message-ID: <20080602030738.GA7761@yantp.cn.ibm.com>
References: <20080228232048.51e28c1d.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756906AbYFBDIB@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080228232048.51e28c1d.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ritesh Raj Sarraf <rrs@researchut.com>, Christophe Saout <christophe@saout.de>, linux-kernel@vger.kernel.org, dm-devel@redhat.com, Herbert Xu <herbert@gondor.apana.org.au>, elliot.li.tech@gmail.com, rjmaomao@gmail.com
List-Id: dm-devel.ids

On Thu, 28 Feb 2008 23:20:48 -0800, Andrew Morton wrote:
> On Thu, 28 Feb 2008 19:24:03 +0530 Ritesh Raj Sarraf <rrs@researchut.com> wrote:
> > I noted kernel soft lockup messages on my laptop when doing a lot of I/O 
> > (200GB) to a dm-crypt device. It was setup using LUKS.
> > The I/O never got disrupted nor anything failed. Just the messages.

I met the same problem yesterday.

> Could be a dm-crypt problem, could be a crypto problem, could even be a
> core block problems.

I think it's due to heavy encryption computation that run longer than
10s and triggered the warning. By heavy I mean dm-crypt with
aes-xts-plain, 512b key size.

This is a typical soft lockup call trace snip from dmesg:
Call Trace:
 [<ffffffff882c60b6>] :xts:crypt+0x9d/0xea
 [<ffffffff882b5705>] :aes_x86_64:aes_encrypt+0x0/0x5
 [<ffffffff882b5705>] :aes_x86_64:aes_encrypt+0x0/0x5
 [<ffffffff882c622e>] :xts:encrypt+0x41/0x46
 [<ffffffff8828273f>] :dm_crypt:crypt_convert_scatterlist+0x7b/0xc7
 [<ffffffff882828ae>] :dm_crypt:crypt_convert+0x123/0x15d
 [<ffffffff88282abd>] :dm_crypt:kcryptd_do_crypt+0x1d5/0x253
 [<ffffffff882828e8>] :dm_crypt:kcryptd_do_crypt+0x0/0x253
 [<ffffffff802448e5>] run_workqueue+0x7f/0x10b
... (omitted)

> If nothing happens in the next few days, yes, please do raise a bugzilla
> report. 

Anybody has done this yet? Or I'll do it.

> If you can provide us with a simple step-by-step recipe to reprodue this,
> and if others can indeed reproduce it, the chances of getting it fixed will
> increase.

Here's my step to reproduce: 

1. You need a moderate computer, it can't be too fast (I'm testing
   this on a Intel(R) Xeon Duo 3040 @ 1.86GHz with 2G ECC RAM on a
   Dell SC440 server, and it's slow enough). On faster computer the
   computation maybe fast enough and not trigger the soft lockup
   detector.

2. Use a 2.6.24+ kernel (I'm using a 2.6.24-etchnhalf.1-amd64 from
   Debian)

3. Create a big partition (or loop file, I think it's OK), at least
   40G.

4. # modprobe xts
   # modprobe aes (or aes-x86_64, same result)
   # cryptsetup -c aes-xts-plain -s 512 luksFormat /dev/sd<Partition>
   # cryptsetup luksOpen /dev/sd<Partition> open_par

5. Do heavy I/O on it, like this:
   # dd if=/dev/zero of=/dev/mapper/open_par

6. After some time (like one hour), run top, I found "kcryptd" is
   running at 100%sy. Check dmesg and I found the soft lockup warning.

I think disk I/O speed is not important here. I'm using a 500G SATA2
drive.

On my server, only AES-XTS with 512 keysize is slow enough to trigger
the lockup detector.  Other slow cryptor such as AES-CBC is OK that I
have test it for hours without any problem.

> Now, I'm assuming that it's just unreasonable for a machine to spend a full
> 11 seconds crunching away on crypto in that code path.  Maybe it _is_
> reasonable, and all we need to do is to poke a cond_resched() in there
> somewhere.

I think this can solve the problem, however, this may harm the
performance of most average users who use only simple crypto such as
CBC-ESSIV, or the performance of high-end server that could handle XTS
with 512b keysize in less than 10s.

Or we can just ignore this problem is there's no data
corruption. Since for moderate computers running XTS with 512 keysize,
the status quo is not very bad, only some dmesg lockup warning and a
unresponsive system. We can add a warning to the document like
"running AES-XTS with 512b key size is a CPU hog and may slow down
your computer."

Anybody see a data corruption?

-- 
Li, Yan
