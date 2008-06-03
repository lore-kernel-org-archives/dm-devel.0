From: "Ritesh Raj Sarraf" <rrs@researchut.com>
Subject: Re: 2.6.24 Kernel Soft Lock Up with heavy I/O in dm-crypt
Date: Wed, 4 Jun 2008 01:16:30 +0530
Message-ID: <2f83bcba0806031246m30f92892wc868d81a9c29d680@mail.gmail.com>
References: <20080602030738.GA7761@yantp.cn.ibm.com>
	<48439890.6030904@redhat.com> <20080602123145.GA8258@yantp.cn.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1138819083=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20080602123145.GA8258@yantp.cn.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Yan Li <elliot.li.tech@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, dm-crypt@saout.de, linux-kernel@vger.kernel.org, dm-devel@redhat.com, rjmaomao@gmail.com, Andrew Morton <akpm@linux-foundation.org>, Milan Broz <mbroz@redhat.com>, Alasdair G Kergon <agk@redhat.com>, Christophe Saout <christophe@saout.de>
List-Id: dm-devel.ids

--===============1138819083==
Content-Type: multipart/alternative;
	boundary="----=_Part_3132_3981123.1212522390419"

------=_Part_3132_3981123.1212522390419
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Following is the bugzilla that was opened against this problem.
http://bugzilla.kernel.org/show_bug.cgi?id=10378

Since I wasn't able to reproduce it on a server machine again, it was later
closed.

If you think it is the same issue, please feel free to re-open it.


Ritesh

On Mon, Jun 2, 2008 at 6:01 PM, Yan Li <elliot.li.tech@gmail.com> wrote:

> Hi Milan,
>
> On Mon, Jun 02, 2008 at 08:52:00AM +0200, Milan Broz wrote:
> > Please could you try if  patch here helps and doesn't cause performance
> degradation?
> >
> http://www2.kernel.org/pub/linux/kernel/people/agk/patches/2.6/2.6.25/dm-crypt-add-cond_resched.patch
>
> Will the result of testing a Debian 2.6.24-etchnhalf.1-amd64 kernel
> (very near a vanilla kernel) be of same value?  Since the data on some
> other drives on this server is important so I dare not try 2.6.25-rc
> on it.
>
> Following is my test plan, comments are welcomed:
>
> Test command:
> # dd if=/dev/zero of=/dev/mapper/open_device bs=500M count=10
> (this server has 2G memory)
>
> The command will be run for 3 times, and average speed of last two
> runs will be taken as result score.
>
> Dm-crypt LUKS Encryption scenarios:
> aes-cbc-essiv:sha256, keysize 128
> aes-xts-plain, keysize 256
> aes-xts-plain, keysize 512
>
> I will compare the speed of all above 3 encryption scenarios, with and
> without the patch.
>
> --
> Li, Yan
>



-- 
Ritesh Raj Sarraf
RESEARCHUT - http://www.researchut.com
"Necessity is the mother of invention."

------=_Part_3132_3981123.1212522390419
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Following is the bugzilla that was opened against this problem.<br><a href="http://bugzilla.kernel.org/show_bug.cgi?id=10378">http://bugzilla.kernel.org/show_bug.cgi?id=10378</a><br><br>Since I wasn&#39;t able to reproduce it on a server machine again, it was later closed.<br>
<br>If you think it is the same issue, please feel free to re-open it.<br><br><br>Ritesh<br><br><div class="gmail_quote">On Mon, Jun 2, 2008 at 6:01 PM, Yan Li &lt;<a href="mailto:elliot.li.tech@gmail.com">elliot.li.tech@gmail.com</a>&gt; wrote:<br>
<blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">Hi Milan,<br>
<div class="Ih2E3d"><br>
On Mon, Jun 02, 2008 at 08:52:00AM +0200, Milan Broz wrote:<br>
&gt; Please could you try if &nbsp;patch here helps and doesn&#39;t cause performance degradation?<br>
&gt; <a href="http://www2.kernel.org/pub/linux/kernel/people/agk/patches/2.6/2.6.25/dm-crypt-add-cond_resched.patch" target="_blank">http://www2.kernel.org/pub/linux/kernel/people/agk/patches/2.6/2.6.25/dm-crypt-add-cond_resched.patch</a><br>

<br>
</div>Will the result of testing a Debian 2.6.24-etchnhalf.1-amd64 kernel<br>
(very near a vanilla kernel) be of same value? &nbsp;Since the data on some<br>
other drives on this server is important so I dare not try 2.6.25-rc<br>
on it.<br>
<br>
Following is my test plan, comments are welcomed:<br>
<br>
Test command:<br>
# dd if=/dev/zero of=/dev/mapper/open_device bs=500M count=10<br>
(this server has 2G memory)<br>
<br>
The command will be run for 3 times, and average speed of last two<br>
runs will be taken as result score.<br>
<br>
Dm-crypt LUKS Encryption scenarios:<br>
aes-cbc-essiv:sha256, keysize 128<br>
aes-xts-plain, keysize 256<br>
aes-xts-plain, keysize 512<br>
<br>
I will compare the speed of all above 3 encryption scenarios, with and<br>
without the patch.<br>
<br>
--<br>
<font color="#888888">Li, Yan<br>
</font></blockquote></div><br><br clear="all"><br>-- <br>Ritesh Raj Sarraf<br>RESEARCHUT - <a href="http://www.researchut.com">http://www.researchut.com</a><br>&quot;Necessity is the mother of invention.&quot;

------=_Part_3132_3981123.1212522390419--


--===============1138819083==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1138819083==--
