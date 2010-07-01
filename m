From: Xinwei Hu <hxinwei@gmail.com>
Subject: Avoiding lvm shell crashes on white space only line
Date: Thu, 1 Jul 2010 14:32:48 +0800
Message-ID: <AANLkTinXwJwplPoZw-AtbzuzKTMuYl6D5x_VbxvKZq7G@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=00c09f97296c93eed9048a4da380
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

--00c09f97296c93eed9048a4da380
Content-Type: text/plain; charset=UTF-8

Hi all,

  lvm shell crashes on white-space only lines.

===>
# lvm
lvm>      <== white spaces
Segmentation fault (core dumped)
<===

  lvm always assuming that argv[0] is accessible. Here's attached a
tentative fix for this issue.
Please consider it for upstream conclusion. ;)

  Thanks

--00c09f97296c93eed9048a4da380
Content-Type: text/x-patch; charset=US-ASCII;
	name="lvm_shell-crashes_on_white_space_only_line.diff"
Content-Disposition: attachment;
	filename="lvm_shell-crashes_on_white_space_only_line.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gb37uzyw0

ZGlmZiAtLWdpdCBhL3Rvb2xzL2x2bS5jIGIvdG9vbHMvbHZtLmMKaW5kZXggZDFjMmY5Yi4uNzgy
YjY0MiAxMDA2NDQKLS0tIGEvdG9vbHMvbHZtLmMKKysrIGIvdG9vbHMvbHZtLmMKQEAgLTIxNyw2
ICsyMTcsMTEgQEAgaW50IGx2bV9zaGVsbChzdHJ1Y3QgY21kX2NvbnRleHQgKmNtZCwgc3RydWN0
IGNtZGxpbmVfY29udGV4dCAqY21kbGluZSkKIAkJCWNvbnRpbnVlOwogCQl9CiAKKwkJaWYgKGFy
Z2MgPT0gMCkgeworCQkJbG9nX2RlYnVnKCJFbXB0eSBpbnB1dCwgc29ycnkuIik7CisJCQljb250
aW51ZTsKKwkJfQorCiAJCWlmICghc3RyY21wKGFyZ3ZbMF0sICJsdm0iKSkgewogCQkJYXJndisr
OwogCQkJYXJnYy0tOwo=
--00c09f97296c93eed9048a4da380
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--00c09f97296c93eed9048a4da380--
