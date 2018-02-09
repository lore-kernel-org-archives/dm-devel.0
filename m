From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH v2 1/7] libmultipath: fix tur checker locking
Date: Sat, 10 Feb 2018 00:28:51 +0100
Message-ID: <1518218931.2937.20.camel@suse.com>
References: <1518134167-15938-1-git-send-email-bmarzins@redhat.com>
	<1518134167-15938-2-git-send-email-bmarzins@redhat.com>
	<1518208256.2937.16.camel@suse.com>
	<20180209230449.GW14513@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-WpDUIQGiPjFVya/PcLN4"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180209230449.GW14513@octiron.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Bart Van Assche <Bart.VanAssche@wdc.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids


--=-WpDUIQGiPjFVya/PcLN4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit

On Fri, 2018-02-09 at 17:04 -0600, Benjamin Marzinski wrote:
> On Fri, Feb 09, 2018 at 09:30:56PM +0100, Martin Wilck wrote:
> > On Thu, 2018-02-08 at 17:56 -0600, Benjamin Marzinski wrote:
> > > ct->running is now an atomic variable.  When the thread is
> > > started
> > > it is set to 1. When the checker wants to kill a thread, it
> > > atomically
> > > sets the value to 0 and reads the previous value.  If it was 1,
> > > the checker cancels the thread. If it was 0, the nothing needs to
> > > be
> > > done.  After the checker has dealt with the thread, it sets ct-
> > > > thread
> > > 
> > > to NULL.
> > > 
> > > When the thread is done, it atomicalllys sets the value of ct-
> > > > running
> > > 
> > > to 0 and reads the previous value. If it was 1, the thread just
> > > exits.
> > > If it was 0, then the checker is trying to cancel the thread, and
> > > so
> > > the thread calls pause(), which is a cancellation point.
> > > 
> > 
> > I'm missing one thing here. My poor brain is aching.
> > 
> > cleanup_func() can be entered in two ways: a) if the thread has
> > been
> > cancelled and passed a cancellation point already, or b) if it
> > exits
> > normally and calls pthread_cleanup_pop(). 
> > In case b), waiting for the cancellation request by calling pause()
> > makes sense to me. But in case a), the thread has already seen the
> > cancellation request - wouldn't calling pause() cause it to sleep
> > forever?
> 
> Urgh. You're right. If it is in the cleanup helper because it already
> has been cancelled, then the pause isn't going get cancelled. So much
> for my quick rewrite.

Maybe it's easier than we thought. Attached is a patch on top of yours
that I think might work, please have a look. 

It's quite late here, so I'll need to ponder your alternatives below
the other day.

Cheers
Martin

> 
> That leaves three options.
> 
> 1. have either the thread or the checker detach the thread (depending
>    on which one exits first)
> 2. make the checker always cancel and detach the thread. This
> simplifies
>    the code, but there will zombie threads hanging around between
> calls
>    to the checker.
> 3. just move the condlog
> 
> I really don't care which one we pick anymore.
> 
> -Ben
> 
> > 
> > Martin
> > 
> > -- 
> > Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
> > SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham
> > Norton
> > HRB 21284 (AG Nürnberg)
> 
> 

-- 
Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)

--=-WpDUIQGiPjFVya/PcLN4
Content-Disposition: attachment;
	filename*0=0001-tur-checker-make-sure-pthread_cancel-isn-t-called-fo.pat;
	filename*1=ch
Content-Type: text/x-patch;
	name="0001-tur-checker-make-sure-pthread_cancel-isn-t-called-fo.patch";
	charset="UTF-8"
Content-Transfer-Encoding: base64

RnJvbSA4MzFlZjI3YjQxODU4ZmEyNDgyMDFiNzRmMmRkOGVhNWI3YzRhZWNlIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBNYXJ0aW4gV2lsY2sgPG13aWxja0BzdXNlLmNvbT4KRGF0ZTog
U2F0LCAxMCBGZWIgMjAxOCAwMDoyMjoxNyArMDEwMApTdWJqZWN0OiBbUEFUQ0hdIHR1ciBjaGVj
a2VyOiBtYWtlIHN1cmUgcHRocmVhZF9jYW5jZWwgaXNuJ3QgY2FsbGVkIGZvciBleGl0ZWQKIHRo
cmVhZAoKSWYgd2UgZW50ZXIgdGhlIGNsZWFudXAgZnVuY3Rpb24gYXMgdGhlIHJlc3VsdCBvZiBh
IHB0aHJlYWRfY2FuY2VsIGJ5IGFub3RoZXIKdGhyZWFkLCB3ZSBkb24ndCBuZWVkIHRvIHdhaXQg
Zm9yIGEgY2FuY2VsbGF0aW9uIGFueSBtb3JlLiBJZiB3ZSBleGl0CnJlZ3VsYXJseSwganVzdCB0
ZWxsIHRoZSBvdGhlciB0aHJlYWQgbm90IHRvIHRyeSB0byBjYW5jZWwgdXMuCi0tLQogbGlibXVs
dGlwYXRoL2NoZWNrZXJzL3R1ci5jIHwgNSArKystLQogMSBmaWxlIGNoYW5nZWQsIDMgaW5zZXJ0
aW9ucygrKSwgMiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9saWJtdWx0aXBhdGgvY2hlY2tl
cnMvdHVyLmMgYi9saWJtdWx0aXBhdGgvY2hlY2tlcnMvdHVyLmMKaW5kZXggODk0YWQ0MWM4OWMz
Li4zMWE4N2QyYjVjZjIgMTAwNjQ0Ci0tLSBhL2xpYm11bHRpcGF0aC9jaGVja2Vycy90dXIuYwor
KysgYi9saWJtdWx0aXBhdGgvY2hlY2tlcnMvdHVyLmMKQEAgLTIyMSw4ICsyMjEsNiBAQCBzdGF0
aWMgdm9pZCBjbGVhbnVwX2Z1bmModm9pZCAqZGF0YSkKIAlob2xkZXJzID0gdWF0b21pY19zdWJf
cmV0dXJuKCZjdC0+aG9sZGVycywgMSk7CiAJaWYgKCFob2xkZXJzKQogCQljbGVhbnVwX2NvbnRl
eHQoY3QpOwotCWlmICghcnVubmluZykKLQkJcGF1c2UoKTsKIH0KIAogc3RhdGljIGludCB0dXJf
cnVubmluZyhzdHJ1Y3QgdHVyX2NoZWNrZXJfY29udGV4dCAqY3QpCkBAIC0yNjYsNiArMjY0LDkg
QEAgc3RhdGljIHZvaWQgKnR1cl90aHJlYWQodm9pZCAqY3R4KQogCXB0aHJlYWRfY29uZF9zaWdu
YWwoJmN0LT5hY3RpdmUpOwogCXB0aHJlYWRfbXV0ZXhfdW5sb2NrKCZjdC0+bG9jayk7CiAKKwkv
KiBUZWxsIG1haW4gY2hlY2tlciB0aHJlYWQgbm90IHRvIGNhbmNlbCB1cywgYXMgd2UgZXhpdCBh
bnl3YXkgKi8KKwlydW5uaW5nID0gdWF0b21pY194Y2hnKCZjdC0+cnVubmluZywgMCk7CisKIAlj
b25kbG9nKDMsICIlczogdHVyIGNoZWNrZXIgZmluaXNoZWQsIHN0YXRlICVzIiwKIAkJdHVyX2Rl
dnQoZGV2dCwgc2l6ZW9mKGRldnQpLCBjdCksIGNoZWNrZXJfc3RhdGVfbmFtZShzdGF0ZSkpOwog
CXR1cl90aHJlYWRfY2xlYW51cF9wb3AoY3QpOwotLSAKMi4xNi4xCgo=


--=-WpDUIQGiPjFVya/PcLN4
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--=-WpDUIQGiPjFVya/PcLN4--
