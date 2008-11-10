From: "Reng Zeng" <alan@fiucssa.org>
Subject: Re: Question about 'dmsetup remove' and dtr of target_type
Date: Sun, 9 Nov 2008 23:15:43 -0500
Message-ID: <60468f1e0811092015q4b9866aagc50bdc9d0cdd54c7@mail.gmail.com>
References: <60468f1e0811082127h3dac5b60h829d871fb38dd63a@mail.gmail.com>
	<20081109082612.GJ14593@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1941304926=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20081109082612.GJ14593@agk.fab.redhat.com>
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

--===============1941304926==
Content-Type: multipart/alternative;
	boundary="----=_Part_18262_32127925.1226290543154"

------=_Part_18262_32127925.1226290543154
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Thanks for reply, you are right, there may be something still holds a
reference of that, which also cause the device busy after 'dmsetup remove'.

I figure out the reason is that, there is one "divide error" which may crash
device mapper, I just do not expect that is the reason why destruction of
target never got invoked.

Thanks very much.

Alan

2008/11/9 Alasdair G Kergon <agk@redhat.com>

> On Sun, Nov 09, 2008 at 12:27:24AM -0500, Reng Zeng wrote:
> > However, I use "dmsetup remove" hundreds times, as the debug info, but it
> > never enter the dtr function I defined.
> > Anybody have idea on this? Or how to dig into that to discover the
> reason?
>
> Something still holds a reference to the table?
> E.g. you have dm_table_get() without a matching dm_table_put() somewhere.
>
> Try a debugger like kgdb?  Check t->holders?
>
> Or post your code here (assuming it's GPL) and someone might help.
>
> Alasdair
> --
> agk@redhat.com
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>

------=_Part_18262_32127925.1226290543154
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Thanks for reply, you are right, there may be something still holds a reference of that, which also cause the device busy after &#39;dmsetup remove&#39;.<br><br>I figure out the reason is that, there is one &quot;divide error&quot; which may crash device mapper, I just do not expect that is the reason why destruction of target never got invoked.<br>
<br>Thanks very much.<br><br>Alan<br><br><div class="gmail_quote">2008/11/9 Alasdair G Kergon <span dir="ltr">&lt;<a href="mailto:agk@redhat.com">agk@redhat.com</a>&gt;</span><br><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
<div class="Ih2E3d">On Sun, Nov 09, 2008 at 12:27:24AM -0500, Reng Zeng wrote:<br>
&gt; However, I use &quot;dmsetup remove&quot; hundreds times, as the debug info, but it<br>
&gt; never enter the dtr function I defined.<br>
&gt; Anybody have idea on this? Or how to dig into that to discover the reason?<br>
<br>
</div>Something still holds a reference to the table?<br>
E.g. you have dm_table_get() without a matching dm_table_put() somewhere.<br>
<br>
Try a debugger like kgdb? &nbsp;Check t-&gt;holders?<br>
<br>
Or post your code here (assuming it&#39;s GPL) and someone might help.<br>
<br>
Alasdair<br>
--<br>
<a href="mailto:agk@redhat.com">agk@redhat.com</a><br>
<font color="#888888"><br>
--<br>
dm-devel mailing list<br>
<a href="mailto:dm-devel@redhat.com">dm-devel@redhat.com</a><br>
<a href="https://www.redhat.com/mailman/listinfo/dm-devel" target="_blank">https://www.redhat.com/mailman/listinfo/dm-devel</a><br>
</font></blockquote></div><br>

------=_Part_18262_32127925.1226290543154--


--===============1941304926==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1941304926==--
