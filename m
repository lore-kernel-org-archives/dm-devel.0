From: Hannes Reinecke <hare@suse.de>
Subject: Re: multipath-0.5.0 still provides broken udev rules
Date: Tue, 26 Apr 2016 07:43:37 +0200
Message-ID: <571F0009.3080903@suse.de>
References: <CAE+k_g+Eh3H1EAiJ0jm7P-efGbOOwpWRtYmvXyR9qhhHtefV7g@mail.gmail.com>
	<571DF852.6030604@redhat.com>
	<CAE+k_gKQcx+QR9bfEp1Wy8BawD14L2G5O0Yw-d0=CffBHqYbrA@mail.gmail.com>
	<571E0E7A.4050703@redhat.com>
	<CABr-GnfxOKz8gxDju20Hx3T9Tn74Zz9FhjF1dBk8weEBJMOmLg@mail.gmail.com>
	<20160425173838.GE26117@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20160425173838.GE26117@octiron.msp.redhat.com>
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

On 04/25/2016 07:38 PM, Benjamin Marzinski wrote:
> On Mon, Apr 25, 2016 at 02:56:35PM +0200, Christophe Varoqui wrote:
>>    Hi,
>>    Those example udev rules are indeed unmaintained and should be remove=
d not
>>    to confuse distributors.
>>    Distributors can't be asked to agree on a common udev ruleset. Ben,
>>    Hannes, Xos=E9, Peter are you ok with my deleting the udev rules exam=
ple ?
> =

> I am personally fine with kpartx.rules being deleted. Red Hat doesn't
> package it.
> =

Well, we do. We use kpartx to generate partitions for multipath and
dmraid, so we do need this rule.
Please do not delete it; if so I will only have to re-add it again
in a SUSE-specific patch.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
