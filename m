From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: LVM snapshot broke between 4.14 and 4.16
Date: Fri, 3 Aug 2018 12:22:09 -0700
Message-ID: <CA+55aFzSM6qhZpM4CCpRNR_LWNCbLyRtQQ3hnPwnRrBdDkwWUw@mail.gmail.com>
References: <CA+55aFyAox9BTDpRsqLXiROhHOX60aa45LEZ7Azteaumdu11Fw@mail.gmail.com>
 <CAOi1vP-SJO4AMK=XD3Lmja++2dQqoiw6Zn8Vgxf8OfvYgnuC6Q@mail.gmail.com>
 <CA+55aFy2DR9fxHhmGq+azSjX9D71YtLsuFKmoEuYW3uTAUYtJg@mail.gmail.com>
 <d76415de-2056-c7d6-cc88-b896deaa8ead@torlan.ru> <1ec0a220-d5b0-1c27-e63b-c4d3f4ce9d77@torlan.ru>
 <CA+55aFyPVQ5-gA93irsaxPC9BNQxnGWrDDHPMUYai2kxKiaKWQ@mail.gmail.com>
 <20180803133102.GA3092@redhat.com> <20180803152034.GD32066@thunk.org>
 <20180803183932.GA3258@redhat.com> <CA+55aFwGGjs_imFFkEPJ4g99Kseam=4Qppv4G6Q=ZfZXdzF7Vw@mail.gmail.com>
 <20180803190617.GA4498@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="000000000000c3424e05728cd81d"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180803190617.GA4498@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Theodore Ts'o <tytso@mit.edu>, Jens Axboe <axboe@kernel.dk>, Sagi Grimberg <sagi@grimberg.me>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-block <linux-block@vger.kernel.org>, dm-devel@redhat.com, Ilya Dryomov <idryomov@gmail.com>, wgh@torlan.ru, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids

--000000000000c3424e05728cd81d
Content-Type: text/plain; charset="UTF-8"

On Fri, Aug 3, 2018 at 12:06 PM Mike Snitzer <snitzer@redhat.com> wrote:
>
> How does that pass for a fix to this issue?
>
> That'll unilaterally mark all dm device's readonly.

Well, if it wasn't honored before anyway, then...

But yes, a much more targeted patch would be preferred.

And in fact, maybe the right thing to do is to not revert the original
commit entirely, but instead just weaken it a lot. Turn the "you did a
write request on a RO disk" into a WARN_ON_ONCE() instead of a hard
error.

Something like the attached patch.

WGH, do you build your own kernels? Does this attached (untested)
patch make things work for you? It should give a big warning, but let
the old behavior through..

                    Linus

--000000000000c3424e05728cd81d
Content-Type: text/x-patch; charset="US-ASCII"; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
Content-ID: <f_jkedkspc0>
X-Attachment-Id: f_jkedkspc0

IGJsb2NrL2Jsay1jb3JlLmMgfCA1ICsrKy0tCiAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25z
KCspLCAyIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2Jsb2NrL2Jsay1jb3JlLmMgYi9ibG9j
ay9ibGstY29yZS5jCmluZGV4IGY4NGE5YjdiNmY1YS4uOTVjYTQ1YmM0ZmM5IDEwMDY0NAotLS0g
YS9ibG9jay9ibGstY29yZS5jCisrKyBiL2Jsb2NrL2Jsay1jb3JlLmMKQEAgLTIxNTUsMTEgKzIx
NTUsMTIgQEAgc3RhdGljIGlubGluZSBib29sIGJpb19jaGVja19ybyhzdHJ1Y3QgYmlvICpiaW8s
IHN0cnVjdCBoZF9zdHJ1Y3QgKnBhcnQpCiAJaWYgKHBhcnQtPnBvbGljeSAmJiBvcF9pc193cml0
ZShiaW9fb3AoYmlvKSkpIHsKIAkJY2hhciBiW0JERVZOQU1FX1NJWkVdOwogCi0JCXByaW50ayhL
RVJOX0VSUgorCQlXQVJOX09OQ0UoCiAJCSAgICAgICAiZ2VuZXJpY19tYWtlX3JlcXVlc3Q6IFRy
eWluZyB0byB3cml0ZSAiCiAJCQkidG8gcmVhZC1vbmx5IGJsb2NrLWRldmljZSAlcyAocGFydG5v
ICVkKVxuIiwKIAkJCWJpb19kZXZuYW1lKGJpbywgYiksIHBhcnQtPnBhcnRubyk7Ci0JCXJldHVy
biB0cnVlOworCQkvKiBPbGRlciBsdm0tdG9vbHMgYWN0dWFsbHkgdHJpZ2dlciB0aGlzICovCisJ
CXJldHVybiBmYWxzZTsKIAl9CiAKIAlyZXR1cm4gZmFsc2U7Cg==
--000000000000c3424e05728cd81d--
