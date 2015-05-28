From: Junichi Nomura <j-nomura@ce.jp.nec.com>
Subject: Re: [PATCH for-4.2 2/3] block,
 dm: don't copy bios for request clones
Date: Thu, 28 May 2015 06:38:29 +0000
Message-ID: <5566B7E5.1070101@ce.jp.nec.com>
References: <1432300445-9543-1-git-send-email-snitzer@redhat.com>
	<1432300445-9543-2-git-send-email-snitzer@redhat.com>
	<556410BB.3000103@ce.jp.nec.com> <20150527082157.GA25993@lst.de>
	<5565935A.4060408@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="_002_5566B7E51070101cejpneccom_"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <5565935A.4060408@ce.jp.nec.com>
Content-Language: ja-JP
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, device-mapper development <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

--_002_5566B7E51070101cejpneccom_
Content-Type: text/plain; charset="iso-2022-jp"
Content-ID: <4AE8DC44BCDCF849857905AF621E789F@gisp.nec.co.jp>
Content-Transfer-Encoding: quoted-printable

On 05/27/15 18:50, Junichi Nomura wrote:
> On 05/27/15 17:21, Christoph Hellwig wrote:
>> On Tue, May 26, 2015 at 06:20:43AM +0000, Junichi Nomura wrote:
>>> Not completing bios is not sufficient.
>>> If you advance the bi_iter to the end, you need to somehow rewind it
>>> or the re-submission will be incomplete, that would end up as a data
>>> corruption...

Less critical than the data corruption issue,
I'm also worried about partial completion case.
For successful partial completion, current code completes
bio before fully completing the request.
Your patch changes bios not completed until the request is
fully completed.

Other related concern is partial failure. In the case of bad sector,
for example, current code fails I/O for the particular sector but
other sectors in the request succeeds.
If you make the request completion as all-or-nothing model,
that will be a degrade for such a case.

I'm not very sure how much impact does the removal of partial
completion have in the real world.
If partial completion is so negligible, I think it should be
handled in such a way all the cases, instead of special casing
REQ_CLONE.

>> Can you explain which particular case you're worried about?
>=20
> General path failure case.
>=20
> On retrying, another clone is created but bios it points to
> are already advanced to the end with your patch.
> So they look like bios with no remaining segments.
> Lower driver may successfully completes such a resubmitted
> clone *without doing actual I/O*.
> Then written data will be lost / read data will be bogus.
>=20
> Can you test this scenario with your patch?
>   1. Set up a multipath device with fail-over mode
>   2. Write something to the multipath device.
>      After the clone request is sent to the primary path
>      and before the data goes to the disk,=20
>      down the primary path
>      (e.g. echo offline > /sys/block/sdXX/device/state)
>   3. (dm-mpath will retry from the secondary path and
>       the write will eventually succeed)
>   4. Verify if the written data is really on the disk

I made a small script so that people can play with.
The script sets up tcm_loop multipath device and fio verification
test while repeating paths up and down quickly.

When your patch is applied, fio reports verification failure within
a minute like this:

# ./stress-mp.sh
..
test1: (g=3D0): rw=3Drandwrite, bs=3D512K-512K/512K-512K/512K-512K, ioengin=
e=3Dlibaio, iodepth=3D2
fio-2.2.8-16-g68d9
Starting 1 process
meta: verify failed at file /dev/mapper/mp offset 477626368, length 524288
       received data dumped as mp.477626368.received
       expected data dumped as mp.477626368.expected
fio: pid=3D13560, err=3D84/file:io_u.c:1866, func=3Dio_u_queued_complete, e=
rror=3DInvalid or incomplete multibyte or wide character

test1: (groupid=3D0, jobs=3D1): err=3D84 (file:io_u.c:1866, func=3Dio_u_que=
ued_complete, error=3DInvalid or incomplete multibyte or wide character): p=
id=3D13560: Thu May 28 01:54:56 2015

--=20
Jun'ichi Nomura, NEC Corporation


--_002_5566B7E51070101cejpneccom_
Content-Type: application/x-sh; name="stress-mp.sh"
Content-Description: stress-mp.sh
Content-Disposition: attachment; filename="stress-mp.sh"; size=1677;
	creation-date="Thu, 28 May 2015 06:38:29 GMT";
	modification-date="Thu, 28 May 2015 06:38:29 GMT"
Content-ID: <BB2C566BA76078498E870B62B85B3450@gisp.nec.co.jp>
Content-Transfer-Encoding: base64

IyEvYmluL2Jhc2gNCg0KbXBkZXY9bXANCg0KIyBFeGl0IGlmICRtcGRldiBhbHJlYWR5IGV4aXN0
cw0KZG1zZXR1cCBpbmZvICRtcGRldiA+Ji9kZXYvbnVsbCAmJiBleGl0IDENCg0KIw0KIyBDcmVh
dGUgbXVsdGlwYXRoIGJhY2tlbmQNCiMNCnRhcmdldGNsaSA8PEVPRiB8fCBleGl0IDENCmNsZWFy
Y29uZmlnIGNvbmZpcm09VHJ1ZQ0KL2JhY2tzdG9yZXMvcmFtZGlzayBjcmVhdGUgcmQgMUcNCi9s
b29wYmFjayBjcmVhdGUgbmFhLjUwMDE0MDExMTExMTExMTENCi9sb29wYmFjayBjcmVhdGUgbmFh
LjUwMDE0MDIyMjIyMjIyMjINCi9sb29wYmFjay9uYWEuNTAwMTQwMTExMTExMTExMS9sdW5zIGNy
ZWF0ZSAvYmFja3N0b3Jlcy9yYW1kaXNrL3JkDQovbG9vcGJhY2svbmFhLjUwMDE0MDIyMjIyMjIy
MjIvbHVucyBjcmVhdGUgL2JhY2tzdG9yZXMvcmFtZGlzay9yZA0KRU9GDQoNCiMNCiMgQ3JlYXRl
IERNIGRldmljZQ0KIw0KZGV2cz0kKGdyZXAgLWwgTElPLU9SRyAvc3lzL2Jsb2NrL3NkKi9kZXZp
Y2UvdmVuZG9yIHwgYXdrIC1GLyAne3ByaW50ICQ0fScgfCBoZWFkIC0yKQ0KbnBhdGg9MA0KZm9y
IGQgaW4gJGRldnM7IGRvDQoJc3o9JChibG9ja2RldiAtLWdldHN6IC9kZXYvJGQpDQoJc3RyPSIk
c3RyIC9kZXYvJHtkfSAxIg0KCW5wYXRoPSQoKG5wYXRoICsgMSkpDQpkb25lDQp0YWJsZT0iMCAk
c3ogbXVsdGlwYXRoIDEgcXVldWVfaWZfbm9fcGF0aCAwIDEgMSBxdWV1ZS1sZW5ndGggMCAkbnBh
dGggMSAkc3RyIg0KZG1zZXR1cCBjcmVhdGUgJG1wZGV2IC0tdGFibGUgIiR0YWJsZSIgfHwgZXhp
dCAxDQpzbGVlcCAzDQoNCiMNCiMgU3RhcnQgZmF1bHQgaW5qZWN0b3INCiMNCmZ1bmN0aW9uIGZh
aWxwYXRoIHsNCglsb2NhbCBtcD0kMQ0KCXNoaWZ0DQoJbG9jYWwgZGV2cz0kKg0KCWxvY2FsIG1h
anM9JChmb3IgZCBpbiAkZGV2czsgZG8gY2F0IC9zeXMvYmxvY2svJGQvZGV2OyBkb25lKQ0KDQoJ
d2hpbGUgdHJ1ZTsgZG8NCgkJZm9yIGQgaW4gJGRldnM7IGRvDQoJCQllY2hvIG9mZmxpbmUgPiAv
c3lzL2Jsb2NrLyR7ZH0vZGV2aWNlL3N0YXRlDQoJCWRvbmUNCgkJZm9yIGQgaW4gJGRldnM7IGRv
DQoJCQllY2hvIHJ1bm5pbmcgPiAvc3lzL2Jsb2NrLyR7ZH0vZGV2aWNlL3N0YXRlDQoJCWRvbmUN
CgkJZm9yIG0gaW4gJG1hanM7IGRvDQoJCQlkbXNldHVwIG1lc3NhZ2UgJG1wIDAgInJlaW5zdGF0
ZV9wYXRoICRtIg0KCQlkb25lDQoJZG9uZQ0KfQ0KZmFpbHBhdGggJG1wZGV2ICRkZXZzICYNCg0K
Iw0KIyBTdGFydCBJTyBnZW5lcmF0b3INCiMNCmZpbyAtLWJzPTUxMmsgLS1ydz1yYW5kd3JpdGUg
LS1kaXJlY3Q9MSAtLWlvZGVwdGg9MiAtLWlvZW5naW5lPWxpYmFpbyBcDQogICAgLS1maWxlbmFt
ZT0vZGV2L21hcHBlci8kbXBkZXYgLS1zaXplPTEwMEcgXA0KICAgIC0tZG9fdmVyaWZ5PTEgLS12
ZXJpZnk9bWV0YSAtLXZlcmlmeV9kdW1wPTEgLS12ZXJpZnlfZmF0YWw9MSBcDQogICAgLS1uYW1l
PXRlc3QxDQppZiBbWyAkPyAtbmUgMCBdXTsgdGhlbg0KCWVjaG8gIkZBSUxFRCINCglyZXQ9MQ0K
ZWxzZQ0KCWVjaG8gIlNVQ0NFU1MiDQoJcmV0PTANCmZpDQoNCiMgU3RvcCBmYXVsdCBpbmplY3Rv
cg0Ka2lsbCAlDQoNCiMgUmVtb3ZlIG1wYXRoIGRldmljZQ0Kc2xlZXAgMw0KZG1zZXR1cCByZW1v
dmUgJG1wZGV2DQoNCmV4aXQgJHJldA0K

--_002_5566B7E51070101cejpneccom_
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--_002_5566B7E51070101cejpneccom_--
