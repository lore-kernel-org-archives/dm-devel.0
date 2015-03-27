From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 78/78] multipathd: trigger all devices on
	startup
Date: Fri, 27 Mar 2015 08:22:32 +0100
Message-ID: <55150538.9000405@suse.de>
References: <1426509425-15978-1-git-send-email-hare@suse.de>
	<1426509425-15978-79-git-send-email-hare@suse.de>
	<20150327055947.GX29132@octiron.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20150327055947.GX29132@octiron.msp.redhat.com>
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
Cc: dm-devel@redhat.com, Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

On 03/27/2015 06:59 AM, Benjamin Marzinski wrote:
> On Mon, Mar 16, 2015 at 01:37:05PM +0100, Hannes Reinecke wrote:
>> During startup multipathd might race with udev and device discovery.
>> During that time any information from libudev might not be fully
>> available, leading to spurious multipathd failures during startup.
>> So instead of scanning all devices on our own we should just
>> re-trigger the existing devices; with that we'll read _all_
>> devices via uevents during startup and avoid the race condition.
> =

> Should we also be sending change uevents for the dm devices?
> =

No. We just need to retrigger the 'sd' devices, as with them we'll
be reconfiguring the dm devices anyway.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
