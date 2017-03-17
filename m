From: michal virgovic <michalvirgovic1@gmail.com>
Subject: Re: [BUG] Oops caused by FEC in 4.10.0
Date: Fri, 17 Mar 2017 13:27:25 +0100
Message-ID: <CAMKhuNG4W8DFP3EzL81vq8xm-gZLLw51zjLbwHJcfgMhyJckcA@mail.gmail.com>
References: <CAMKhuNG_AKfY_EB9C_Y-8q7sR+9u+Mn9w-hb1YvZQBCNLC_-ww@mail.gmail.com>
	<20170315221223.GA116381@samitolvanen.mtv.corp.google.com>
	<accf7e0f-1964-6e19-9453-a1c27e3666d4@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=f403045f83d4e3d3cc054aec4c31
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <accf7e0f-1964-6e19-9453-a1c27e3666d4@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Milan Broz <mbroz@redhat.com>
Cc: dm-devel@redhat.com, agk@redhat.com, snitzer@redhat.com, Sami Tolvanen <samitolvanen@google.com>
List-Id: dm-devel.ids

--f403045f83d4e3d3cc054aec4c31
Content-Type: text/plain; charset=UTF-8

2017-03-17 12:45 GMT+01:00 Milan Broz <mbroz@redhat.com>:

> I tried it and it still does take at least two minutes and tons of logs until even
> udev scan finishes on a device with incorrect FEC attributes.
>
> And once it is finished, dm-verity crashes on dm-device removal...

I tried it too, but with correctly computed root-hash, salt,
hash-device, fec-device (using veritysetup) and the outcome is same.

Attachment file is the script i used.

--f403045f83d4e3d3cc054aec4c31
Content-Type: application/octet-stream; name=test_FEC
Content-Disposition: attachment; filename=test_FEC
Content-Transfer-Encoding: base64
X-Attachment-Id: f_j0dsrosl0

IyEvYmluL2Jhc2ggLXgKCiMgZmFpbHMgb24ga2VybmVsIDQuMTAuMAoKREVWX05BTUU9dGVzdF9k
ZXZpY2UKREVWX0RBVEE9dGVzdF9kYXRhCkRFVl9EQVRBX0w9L2Rldi9sb29wMApERVZfSEFTSD1o
YXNoX2RldgpERVZfSEFTSF9MPS9kZXYvbG9vcDEKREVWX0ZFQz1mZWNfZGV2CkRFVl9GRUNfTD0v
ZGV2L2xvb3AyCgojIGNsb25lIGNyeXB0c2V0dXAKIyBjaGVja291dCB3aXAtZmVjIGJyYW5jaCBh
bmQgYnVpbGQgaXQKVlNfTE9DQVRJT049Y3J5cHRzLWZlYy9zcmMvdmVyaXR5c2V0dXAKCiMgY3Jl
YXRlIGRhdGEgd2l0aCBkZCAoc2l6ZT00MDk2MDAwMCBCKQpkZCBpZj0vZGV2L3plcm8gb2Y9JERF
Vl9EQVRBIGJzPTQwOTYgY291bnQ9MTAwMDAKCiMgY2FsY3VsYXRlICh3aXRoIHZlcml0eXNldHVw
IGZvcm1hdCkgY29ycmVjdCByb290IGRpZ2VzdCBhbmQgc2FsdCwgc28gUlMgd29uJ3QgcmVwYWly
IGVyYXN1cmVzICsgaGFzaCBkZXZpY2Ugd2lsbCBiZSBjcmVhdGVkICsgZ2V0IHNhbHQgYW5kIHJv
b3QgaGFzaCBmcm9tIG91dHB1dApBUlJBWT0oYCRWU19MT0NBVElPTiAtLWZlYy1yb290cz0xMCAt
LWZlYy1kZXZpY2U9JERFVl9GRUMgZm9ybWF0ICRERVZfREFUQSAkREVWX0hBU0hgKQpTQUxUPSR7
QVJSQVlbMjVdfQpST09UX0hBU0g9JHtBUlJBWVsyOF19CkRBVEFfQkxPQ0tTPSR7QVJSQVlbMTJd
fQoKQVJSQVk9KGBscyAtbCAkREVWX0RBVEEgJERFVl9IQVNIYCkKVE9UQUxfQkxPQ0tTPSQoKCgo
JHtBUlJBWVs0XX0rJHtBUlJBWVsxM119KS80MDk2KS0xKSkKCmxvc2V0dXAgJERFVl9EQVRBX0wg
JERFVl9EQVRBCmxvc2V0dXAgJERFVl9IQVNIX0wgJERFVl9IQVNICmxvc2V0dXAgJERFVl9GRUNf
TCAkREVWX0ZFQwoKIyBjcmVhdGUgZGV2aWNlIHdpdGggZG1zZXR1cCB3aXRoIHNwZWNpZmllZCB0
YWJsZQpkbXNldHVwIC1yIGNyZWF0ZSAkREVWX05BTUUgLS10YWJsZSAiMCAkKCgkREFUQV9CTE9D
S1MqOCkpIHZlcml0eSAxICRERVZfREFUQV9MICRERVZfSEFTSF9MIDQwOTYgNDA5NiAkREFUQV9C
TE9DS1MgMCBzaGEyNTYgJFJPT1RfSEFTSCAkU0FMVCA4IHVzZV9mZWNfZnJvbV9kZXZpY2UgJERF
Vl9GRUNfTCBmZWNfcm9vdHMgMTAgZmVjX2Jsb2NrcyAkVE9UQUxfQkxPQ0tTIGZlY19zdGFydCAw
IgoKIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMj
IyMjIyMjIyMjIyMjIwoKZG1zZXR1cCB0YWJsZSAkREVWX05BTUUKZG1zZXR1cCBscwoKIyB3YWl0
IHVudGlsIHVkZXYgYmxraWQgZmluaXNoZXMgLSB0aGlzc2hvdWxkIGJlIHF1aWNrIGJ1dCBhcHBh
cmVudGx5IHZlcml0eSBpcyB0cnlpbmcgcmVjb3ZlciBtb3JlIHRoYW4gaXQgc2hvdWxkCnVkZXZh
ZG0gc2V0dGxlCgojIGNsZWFuCmRtc2V0dXAgcmVtb3ZlICRERVZfTkFNRQpsb3NldHVwIC1kICRE
RVZfREFUQV9MCmxvc2V0dXAgLWQgJERFVl9IQVNIX0wKbG9zZXR1cCAtZCAkREVWX0ZFQ19MCnJt
ICRERVZfSEFTSCAkREVWX0ZFQyAkREVWX0RBVEEK
--f403045f83d4e3d3cc054aec4c31
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--f403045f83d4e3d3cc054aec4c31--
