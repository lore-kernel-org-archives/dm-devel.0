From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-crypt: support using encrypted keys
Date: Wed, 22 Apr 2020 17:40:52 -0400
Message-ID: <20200422214052.GA10695@redhat.com>
References: <20200420134659.1640089-1-dbaryshkov@gmail.com>
	<20200421182754.GA49104@lobo>
	<e3b78a32-4307-c60c-f9c3-dd6d71b6633c@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <e3b78a32-4307-c60c-f9c3-dd6d71b6633c@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Disposition: inline
To: Milan Broz <gmazyland@gmail.com>
Cc: Dmitry Baryshkov <dbaryshkov@gmail.com>, Dmitry Baryshkov <dmitry_baryshkov@mentor.com>, David Howells <dhowells@redhat.com>, dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Wed, Apr 22 2020 at 12:47pm -0400,
Milan Broz <gmazyland@gmail.com> wrote:

> On 21/04/2020 20:27, Mike Snitzer wrote:
> > On Mon, Apr 20 2020 at  9:46P -0400,
> > Dmitry Baryshkov <dbaryshkov@gmail.com> wrote:
> > 
> >> From: Dmitry Baryshkov <dmitry_baryshkov@mentor.com>
> >>
> >> Allow one to use encrypted in addition to user and login key types for
> >> device encryption.
> >>
> >> Signed-off-by: Dmitry Baryshkov <dmitry_baryshkov@mentor.com>
> > 
> > I fixed up some issues, please see the following incremental patch,
> > I'll get this folded in and staged for 5.8.
> 
> And you just created hard dependence on encrypted key type...
> 
> If you disable this type (CONFIG_ENCRYPTED_KEYS option), it cannot load the module anymore:
> ERROR: modpost: "key_type_encrypted" [drivers/md/dm-crypt.ko] undefined!

Yes, I was made aware via linux-next last night.

> We had this idea before, and this implementation in dm-crypt just requires dynamic
> key type loading implemented first.
>
> David Howells (cc) promised that moths ago, but apparently nothing was yet submitted
> (and the proof-of-concept patch no longer works).

Why is it so bad for dm-crypt to depend on CONFIG_ENCRYPTED_KEYS while
we wait for the innovation from David?
 
> Mike, I think you should revert this patch from the tree until it is solved.
> 
> Once fixed, we should also support "trusted" key type.
> 
> Also please -  do no forget to increase dm-crypt minor version here...

I fixed the patch up and staged it in linux-next to get test coverage,
see:
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=for-next&id=5eb07fda05fbf87d9a37939d1cd445203c55e126

Doesn't mean I intend to keep it staged; just would like to validate the
patch before tabling it (if that's what is ultimately decided for now).

Mike
