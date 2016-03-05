From: Gris Ge <fge@redhat.com>
Subject: Re: [PATCH V2] Introducing multipath C API
 <libdmmp/libdmmp.h>
Date: Sat, 5 Mar 2016 17:46:49 +0800
Message-ID: <20160305094649.GA948@redhat.com>
References: <56AF5F58.6030302@suse.de>
	<1455264623-16199-1-git-send-email-fge@redhat.com>
	<1455264623-16199-2-git-send-email-fge@redhat.com>
	<20160304160624.GN2915@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5296191410522493116=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20160304160624.GN2915@octiron.msp.redhat.com>
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
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids


--===============5296191410522493116==
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="bp/iNruPH9dso1Pn"
Content-Disposition: inline


--bp/iNruPH9dso1Pn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 04, 2016 at 10:06:24AM -0600, Benjamin Marzinski wrote:
> On Fri, Feb 12, 2016 at 04:10:23PM +0800, Gris Ge wrote:
>
> This looks good to me. Personally, I would have loved to see
> multipathd actually passing structured data across the IPC
> connection, and have the multipath client code responsible for
> making it pretty, but making that happen is a lot more invasive.
Hi Benjamin,

Thanks for the review.

I believe Todd is trying to patch multipathd IPC to provide JSON
output like:
    multipathd -k'show topology json'
>
> A couple of thoughts:
>
> I'm wrote a library interface for the multipath IPC code that wasn't
> included the upstream code, although nobody ever voiced a
> disagreement with it, and Hannes sounded supportive of it the last
> time I posted it.
>
> https://www.redhat.com/archives/dm-devel/2015-June/msg00033.html
> https://www.redhat.com/archives/dm-devel/2015-October/msg00062.html
>
> I plan on resending it with my next batch of patches, unless someone
> wants to tell me why it hasn't been accepted before.  It doesn't
> effect your code at all, but assuming that it does get in this time,
> we may want to make some of your IPC functions wrappers around it
> (possibly modifying my library code to work with it better), so that
> we aren't duplicating work.
It's good to remove duplicate code between daemon and client on the
IPC communication.
I will update my patch to unitize libmpath_cmd once it has been
committed.
>
> Also, why use the assert, instead of returning an error? I know some
> library's don't protect you from passing in NULL pointers, and just let
> you segfault.  I didn't find any cases where you would return junk if
> the asserts were disabled, but I didn't follow through all of the logic
> to verify that you wouldn't ever return junk if you passed in junk and
> the asserts were disabled.
Without assert, I have to provide a return code
(for example: DMMP_ERR_INVALID_ARGUMENT) and clean up all possible
messes.

Example:

    int dmmp_mpath_array_get(struct dmmp_context *ctx,
                             struct dmmp_mpath ***dmmp_mps,
                             uint32_t *dmmp_mp_count);

If any of three argument is NULL, I have to set output pointer as
NULL(if not NULL) just in case user use them without checking return
code.

Meanwhile, I have to set error message to indicate so when ctx is not
NULL.

IMHO, using error handling on this simple programmer fault is waste of
time. It seems assert is enough for this.
>
> Lastly, and this is even more nit-picky, in _dmmp_all_get_func_gen,
> why to you need to pass in a specific name for the array and the
> item_count?
It's my bad habit of keeping function prototype identical(including
argument name) to implementation.
I will purge them in V3 patch.
>
> But regardless of these nit-picks, ACK.
>
> -Ben
Best regards.

--=20
Gris Ge

--bp/iNruPH9dso1Pn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJW2qsFAAoJEGzN5Y/kHij/eNwP/2SGcdu10QgFlxMvIIO9U7q/
LhRLhvR+ybDCosw0iIdoi3i2/ASuKp+kG4rKHFGsCvvHP41pFag9ehCouS26S7Xj
MWoXGKIoosTYiAZu+WhWBHynsRuBNXdT/k5+hah46fwlkzHsLnx+s+lLAIh0Vemi
6jhl/hXPkpkqR6ojjiXYedem9oDwyKAjVELxfX6Xq5KYapbG3eL7d1JuzH9Sti93
H1sHdsuYdavvUXCVr7BQjTEI5ZoIyNUJuF/p+H+GKiaoK53oQH9mBvDAvB9iTSxR
gYBKORzPQWEZBhdvzVmZQTSi7jVdr1eVagWXk924g6Z3WT9S8rxpOwQtzFYAMXmb
U77l2L4IOAot/swpALhaAbMzqidtIoq/u6dq3O6KJ/V/t5abDzcoUE9L2xcX+RVs
4/BVGixzsV3nBBVLSu3CTi3w/iwTqJ+dIXs5J7aanDMuRL3CCVZaX3Lsz7kHhMQ/
lckEoBHcV3b6aR/29yi4CDHIvtsKDYzoHIX9AY1wPQ8uH93tlh0P+KJf5eKH0wav
cJA6lEMRNZP2qSD2j84jgguJffAVFFIUET70K1K59qTAY4qrxauIYwDB0/iOsQwe
wUDGZqrYqzOJTUbBqcBUtlzdqsx8xwSZDcROIxgZGDGqF8PjieCIA4dHS+rrBqI6
wUT5gDsd3R0srxmEjjD+
=MeyJ
-----END PGP SIGNATURE-----

--bp/iNruPH9dso1Pn--


--===============5296191410522493116==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============5296191410522493116==--
