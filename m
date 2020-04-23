From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-crypt: support using encrypted keys
Date: Thu, 23 Apr 2020 10:06:12 -0400
Message-ID: <20200423140612.GA14885@redhat.com>
References: <20200420134659.1640089-1-dbaryshkov@gmail.com>
	<20200421182754.GA49104@lobo>
	<e3b78a32-4307-c60c-f9c3-dd6d71b6633c@gmail.com>
	<20200422214052.GA10695@redhat.com>
	<67eedf43-7afb-3c2e-704a-d0ac187d6a4b@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <67eedf43-7afb-3c2e-704a-d0ac187d6a4b@gmail.com>
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

On Thu, Apr 23 2020 at  2:47am -0400,
Milan Broz <gmazyland@gmail.com> wrote:

> On 22/04/2020 23:40, Mike Snitzer wrote:
> > On Wed, Apr 22 2020 at 12:47pm -0400,
> > Milan Broz <gmazyland@gmail.com> wrote:
> > 
> >> On 21/04/2020 20:27, Mike Snitzer wrote:
> >>> On Mon, Apr 20 2020 at  9:46P -0400,
> >>> Dmitry Baryshkov <dbaryshkov@gmail.com> wrote:
> >>>
> >>>> From: Dmitry Baryshkov <dmitry_baryshkov@mentor.com>
> >>>>
> >>>> Allow one to use encrypted in addition to user and login key types for
> >>>> device encryption.
> >>>>
> >>>> Signed-off-by: Dmitry Baryshkov <dmitry_baryshkov@mentor.com>
> >>>
> >>> I fixed up some issues, please see the following incremental patch,
> >>> I'll get this folded in and staged for 5.8.
> >>
> >> And you just created hard dependence on encrypted key type...
> >>
> >> If you disable this type (CONFIG_ENCRYPTED_KEYS option), it cannot load the module anymore:
> >> ERROR: modpost: "key_type_encrypted" [drivers/md/dm-crypt.ko] undefined!
> > 
> > Yes, I was made aware via linux-next last night.
> > 
> >> We had this idea before, and this implementation in dm-crypt just requires dynamic
> >> key type loading implemented first.
> >>
> >> David Howells (cc) promised that moths ago, but apparently nothing was yet submitted
> >> (and the proof-of-concept patch no longer works).
> > 
> > Why is it so bad for dm-crypt to depend on CONFIG_ENCRYPTED_KEYS while
> > we wait for the innovation from David?
> 
> People need to compile kernel with specific features disabled, even without keyring sometimes.
> We also support whole CONFIG_KEYS disable - and it makes sense for some small appliances.
> 
> In fact I had similar patch (support for encrypted+trusted keyes) for dm-crypt for months,
> with additional patch that loads key types per requests (so it can fail if the type is not available).
> It uses key_type_lookup function exported. IMO this is the way to go.
> 
> So the idea is good, but please keep possibility to disable it.
> Additional dependencies not only cause problems above, but also can get some failures from initrd
> where the new module is missing (that happened several times, it is just problem
> that can be easily avoided).

Seems you didn't look at the fixed patch, here is what I ultimately
staged yesterday:
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-5.8&id=a2b35bd064baf1f4e7504c23d493a3e149172dd1

dm-crypt doesn't have a hard dependency on CONFIG_ENCRYPTED_KEYS.  If it
is enabled support will be available, if not enabled support isn't.

The concern about initramfs not having dep modules is a kernel tooling
support issue.  Not seeing any point withholding capabilities out of
paranoia that a particular distribution's tooling (initramfs generation
upon kernel update) isn't working as needed.

Mike
