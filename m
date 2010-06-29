From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] [RFC] [PATCH] Add alias_prefix to get
 multipath names based on	storage type
Date: Tue, 29 Jun 2010 07:57:18 +0200
Message-ID: <4C298B3E.7030907@suse.de>
References: <b4d519b4bbc657671382.1277260053@malahal>
	<20100628230737.GA17462@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20100628230737.GA17462@us.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: christophe.varoqui@free.fr, dm-devel@redhat.com
List-Id: dm-devel.ids

Malahal Naineni wrote:
> Any comments??
> =

> Malahal Naineni [malahal@us.ibm.com] wrote:
>> The current multipath tools use "mpath" prefix for all LUNs when
>> user_friendly_names is set. It would be nice if the names are generated
>> based on the storage subsystem. For example, all EMC LUNs would be named
>> emc_a, emc_b, elm_c etc., and all IBM's SVC LUNs would be named svc_a,
>> svc_b, svc_c. This patch attempts to do that using only multipath.conf.
>> Patches can be added to the internal hardware table, if needed.
>>
I like it. Having an option to modify the alias prefix is something
I always wanted to have.
You could update the manpage, though.

Acked-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
