From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 68/78] libmultipath: unset 'uid_attribute' on
	failure
Date: Fri, 27 Mar 2015 08:17:47 +0100
Message-ID: <5515041B.1040505@suse.de>
References: <1426509425-15978-1-git-send-email-hare@suse.de>
	<1426509425-15978-69-git-send-email-hare@suse.de>
	<20150327041037.GS29132@octiron.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20150327041037.GS29132@octiron.msp.redhat.com>
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

On 03/27/2015 05:10 AM, Benjamin Marzinski wrote:
> On Mon, Mar 16, 2015 at 01:36:55PM +0100, Hannes Reinecke wrote:
>> Due to a race condition within udev the 'uid_attribute'
>> might not always be set. So we should be zeroing the
>> 'uid_attribute' when retrieving the uid by other means,
>> otherwise the discovery process will blacklist the device.
> =

> Possibly I'm just missing obvious here, but I don't get the point of
> zeroing out the uid_attribute.  Won't it just get reset on the next call
> to get_uid?
> =

The uid_attribute setting is evaluated later on, so when we're not
zeroing it the code assumes we've got the UID from the udev
attribute, which is untrue.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
