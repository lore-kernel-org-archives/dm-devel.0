From: NeilBrown <neilb@suse.com>
Subject: Re: [dm-devel] [LSF/MM TOPIC] block, dm: restack queue_limits
Date: Fri, 02 Feb 2018 16:59:55 +1100
Message-ID: <87607g2ap0.fsf@notabene.neil.brown.name>
References: <20180129210836.GA5744@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20180129210836.GA5744@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>, linux-block@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

--=-=-=
Content-Type: text/plain

On Mon, Jan 29 2018, Mike Snitzer wrote:

> We currently don't restack the queue_limits if the lowest, or
> intermediate, layer of an IO stack changes.
>
> This is particularly unfortunate in the case of FLUSH/FUA which may
> change if/when a HW controller's BBU fails; whereby requiring the device
> advertise that it has a volatile write cache (WCE=1).
>
> But in the context of DM, really it'd be best if the entire stack of
> devices had their limits restacked if any underlying layer's limits
> change.
>
> In the past, Martin and I discussed that we should "just do it" but
> never did.  Not sure we need a lengthy discussion but figured I'd put it
> out there.

So much "yes"!!
Just a notifier chain would probably do.

I would like the notification to support changing the size of the device
too.
I see this as being two-stage.
1/ I'm going to change the device size to X - are you all OK with that?
2/ Device size is now X.

That allows md and dm to check that filesystems aren't going to get mad
when devices are made smaller, and can adjust (if they want to) when
devices get bigger.

Thanks,
NeilBrown

>
> Maybe I'll find time, between now and April, to try implementing it.
>
> Thanks,
> Mike
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlpz/lsACgkQOeye3VZi
gbn4QhAAwrK92tzJOSGQBiXNSHoZWcWZRwTl0AxKj1ZYzCjeifxig8XVdYUky8YK
zGZzNttyc7S2tQ/+jbhyyWhAQ5vnNw0OI7UtU3nhcK6eSdAoiwKn1Hpy0fS/ybEJ
5HaP/25TshhvgM0o1M2xCfGJ/GIRKbmGtUfqRGWkB55o0O6DCqSxMTiTwLEobBlq
qONisCYfiStrFyfJKEOc1nCOVpqXhYW1zbWX8lWbHin/5RLMlCLbluF8kGH3TNCV
Rce2rWbd/vcVpITyCo7Mmq3nlvGQREf/GFMlMG0amKzrNi6KUXWNRQDYNw3vyAf8
t22HburtmneedDQQEVM/XxzASC/s/bv14y8WH5Xh/q+9Ny+45FqSgEK8lY8xjK8n
2ul3h2QbC3m6GIXTLyzT/PkpH3qBI6F5hVqDKgYkTJrLwd6mED2CNsPLOkM68f0G
HuQc17JbEKqoyj5hUDlNqenUi2ffyzlf+nicdg12GhiPw2bW5gYo2x8+5Rnb8sTf
PutNEFKyJJS7YxFE8wZ3v4EmMgA4xIoc0gKq5mbafzyS0HcGz7J4+t2Lyjfn2KRF
6aBKw1klui4dhFb+pcbpkDujYS1EJ/UJG/MnmLedda3FlzgP1I050W8nhCQ0ZSXK
NcmZEo2BPNxzSnkyPr7mWwlV3hT0yz0cpnHlf1pVao8sGefWca8=
=aSpN
-----END PGP SIGNATURE-----
--=-=-=--
