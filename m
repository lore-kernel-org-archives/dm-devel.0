From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: default value for rr_min_io too high?
Date: Wed, 18 Jan 2006 23:29:59 +0100
Message-ID: <1137623400.15100.11.camel@zezette>
References: <43CEB625.9000503@netapp.com>
Reply-To: christophe.varoqui@free.fr,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <43CEB625.9000503@netapp.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On mer, 2006-01-18 at 16:41 -0500, David Wysochanski wrote:
> I'm wondering where the value of 1000 came from, and
> whether that's really a good default.
> 
> Some preliminary tests I've run with iSCSI seem to indicate
> something lower (say 100) might be a better default, but
> perhaps others have a differing opinion.  I searched the
> list but couldn't find any discussion on it.
> 
I'm not really focused on performance, but this seems to be an
io-pattern dependant choice.

Higher values may help the elevators, (right ?) thus help the seeky
workloads. Lower values may certainly benefit from lower values to
really get the paths summed bandwidth.

Anyway, I can not back this with numbers. Any value will be fine with me
as a default, and I highlight that now you can also set per device
defaults like rr_min_io in hwtable.c

Regards,
cvaroqui
