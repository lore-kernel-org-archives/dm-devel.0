From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 0/6] Delete attributes with default values
Date: Mon, 11 Jul 2016 16:33:21 +0200
Message-ID: <5783AE31.5040406@suse.de>
References: <1468022328-5905-1-git-send-email-xose.vazquez@gmail.com>
	<CABr-GncP-rzeXogT1EFZTtFrre2UUSV6i-AJ27GZ3mTvcxx-7Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CABr-GncP-rzeXogT1EFZTtFrre2UUSV6i-AJ27GZ3mTvcxx-7Q@mail.gmail.com>
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

On 07/09/2016 10:17 AM, Christophe Varoqui wrote:
> I'll wait for comments from distribution maintainers on this patchset.
> =

> Because, though we have already deleted the checker_name settings when
> equal to the default value, it should be clear that with this patchset
> changing a default may cause re-certification for all impacted devices.
> This can be viewed as a problem for distributors.
> =

> Hannes, Ben, do you ack this patchset ? If not, what do we do the
> checker_name settings, that I understood Hannes wanted to switch to TUR
> anyway.
> =

That is fine. Eliminating the default values shouldn't cause any issues
with us.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
