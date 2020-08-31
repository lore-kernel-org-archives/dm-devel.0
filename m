From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH V3 2/5] multipathd: use daemon_status_msg to
 construct sd notify msg in do_sd_notify func
Date: Mon, 31 Aug 2020 11:55:48 +0200
Message-ID: <cb97dfa97281bf9fe6738ffbf6abb20b5e2991ae.camel@suse.com>
References: <dc4f5730-157f-8a27-247c-628f38bb6cb5@huawei.com>
	<8e24c49b-6f56-e7ea-7f2a-e7bd9d266e23@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-Mb/0r6fdD7qL3QWJTAR8"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <8e24c49b-6f56-e7ea-7f2a-e7bd9d266e23@huawei.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Cc: lixiaokeng <lixiaokeng@huawei.com>, yanxiaodan@huawei.com, linfeilong@huawei.com, dm-devel@redhat.com, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids

--=-Mb/0r6fdD7qL3QWJTAR8
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit

Hello Zhiqiang,

On Sat, 2020-08-29 at 11:03 +0800, Zhiqiang Liu wrote:
> sd_notify_status() is very similar with daemon_status(), except
> DAEMON_IDLE and DAEMON_RUNNING state. As suggested by Martin,
> we can create the sd notification string in a dynamic buffer,
> and treat DAEMON_IDLE and DAEMON_RUNNING cases first. Then,
> we can use daemon_status_msg[state] for other cases.
> 
> V2->V3:
> - set MSG_SIZE to 32 and use safe_sprintf as suggested by Martin.
> 
> Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
> Signed-off-by: lixiaokeng <lixiaokeng@huawei.com>
> ---
>  multipathd/main.c | 34 ++++++++++++----------------------
>  1 file changed, 12 insertions(+), 22 deletions(-)

Thanks again. I'd like to modify the patch slightly as attached. 
I'm sorry that I didn't mention these minor issues in my previous
reviews. I'm sending you the fixup patch in order to short-circuit 
the procedure a bit and save both of us some work.

Would this be ok for you?
If yes, please resubmit this as v4.

Regards,
Martin


--=-Mb/0r6fdD7qL3QWJTAR8
Content-Disposition: attachment;
	filename*0=0001-fixup-multipathd-use-daemon_status_msg-to-construct-.pat;
	filename*1=ch
Content-Type: text/x-patch;
	name="0001-fixup-multipathd-use-daemon_status_msg-to-construct-.patch";
	charset="ISO-8859-15"
Content-Transfer-Encoding: base64

RnJvbSA3MzkxNWZiMzJiMmIwZDIzM2VlOTA4YTQ3ODk2MTNjMDNjMjcyODVlIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBNYXJ0aW4gV2lsY2sgPG13aWxja0BzdXNlLmNvbT4KRGF0ZTog
TW9uLCAzMSBBdWcgMjAyMCAxMTo0Mzo1NiArMDIwMApTdWJqZWN0OiBbUEFUQ0hdIGZpeHVwISBt
dWx0aXBhdGhkOiB1c2UgZGFlbW9uX3N0YXR1c19tc2cgdG8gY29uc3RydWN0IHNkCiBub3RpZnkg
bXNnIGluIGRvX3NkX25vdGlmeSBmdW5jCgogLSBubyBuZWVkIHRvIGluaXRpYWxpemUgbXNnLCBp
dCdzIGFsd2F5cyBzZXQKIC0gbXNnIGNvdWxkIGJlIE5VTEwsIGF0IGxlYXN0IGluIHRoZW9yeSwg
c28gY2hlY2sgcmV0dXJuIHZhbHVlIGJlZm9yZSBwYXNzaW5nCiBpdCB0byBzbnByaW50ZigpCiAt
IGF2b2lkICJwcmVmaXgiIHZhcmlhYmxlOyByYXRoZXIgcHV0IHRoZSBwcmVmaXggaW4gZm9ybWF0
IHN0cmluZwotLS0KIG11bHRpcGF0aGQvbWFpbi5jIHwgNSArKy0tLQogMSBmaWxlIGNoYW5nZWQs
IDIgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9tdWx0aXBhdGhk
L21haW4uYyBiL211bHRpcGF0aGQvbWFpbi5jCmluZGV4IDVkZjAwNGEuLmY3MjI5YTcgMTAwNjQ0
Ci0tLSBhL211bHRpcGF0aGQvbWFpbi5jCisrKyBiL211bHRpcGF0aGQvbWFpbi5jCkBAIC0xODMs
OCArMTgzLDcgQEAgc3RhdGljIHZvaWQgZG9fc2Rfbm90aWZ5KGVudW0gZGFlbW9uX3N0YXR1cyBv
bGRfc3RhdGUsCiAJCQkgZW51bSBkYWVtb25fc3RhdHVzIG5ld19zdGF0ZSkKIHsKIAljaGFyIG5v
dGlmeV9tc2dbTVNHX1NJWkVdOwotCWNvbnN0IGNoYXIgcHJlZml4W10gPSAiU1RBVFVTPSI7Ci0J
Y29uc3QgY2hhciAqbXNnID0gTlVMTDsKKwljb25zdCBjaGFyICptc2c7CiAJLyoKIAkgKiBDaGVj
a2VybG9vcCBzd2l0Y2hlcyBiYWNrIGFuZCBmb3J0aCBiZXR3ZWVuIGlkbGUgYW5kIHJ1bm5pbmcg
c3RhdGUuCiAJICogTm8gbmVlZCB0byB0ZWxsIHN5c3RlbWQgZWFjaCB0aW1lLgpAQCAtMTk5LDcg
KzE5OCw3IEBAIHN0YXRpYyB2b2lkIGRvX3NkX25vdGlmeShlbnVtIGRhZW1vbl9zdGF0dXMgb2xk
X3N0YXRlLAogCWVsc2UKIAkJbXNnID0gZGFlbW9uX3N0YXR1c19tc2dbbmV3X3N0YXRlXTsKIAot
CWlmICghc2FmZV9zcHJpbnRmKG5vdGlmeV9tc2csICIlcyVzIiwgcHJlZml4LCBtc2cpKQorCWlm
IChtc2cgJiYgIXNhZmVfc3ByaW50Zihub3RpZnlfbXNnLCAiU1RBVFVTPSVzIiwgbXNnKSkKIAkJ
c2Rfbm90aWZ5KDAsIG5vdGlmeV9tc2cpOwogfQogI2VuZGlmCi0tIAoyLjI4LjAKCg==
--=-Mb/0r6fdD7qL3QWJTAR8
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--=-Mb/0r6fdD7qL3QWJTAR8--
