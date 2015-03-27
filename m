From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 50/78] Allow zero-sized devices during
	configuration
Date: Fri, 27 Mar 2015 08:16:23 +0100
Message-ID: <551503C7.1010007@suse.de>
References: <1426509425-15978-1-git-send-email-hare@suse.de>
	<1426509425-15978-51-git-send-email-hare@suse.de>
	<20150327035609.GR29132@octiron.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20150327035609.GR29132@octiron.msp.redhat.com>
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

On 03/27/2015 04:56 AM, Benjamin Marzinski wrote:
> On Mon, Mar 16, 2015 at 01:36:37PM +0100, Hannes Reinecke wrote:
>> A size of '0' doesn't indicate an invalid device; other paths might
>> end up with a correct size.
> =

> don't we also need to change this is ev_add_path, then?
> =

Probably. I'll check.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
