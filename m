From: Bastian Blank <bastian@waldi.eu.org>
Subject: Re: multipath-tool udev rules require missing dmsetup
	features
Date: Sun, 12 Aug 2007 20:21:44 +0200
Message-ID: <20070812182144.GA16910@wavehammer.waldi.eu.org>
References: <469EB881.6070207@csupomona.edu>
	<20070719061622.GB21899@pentland.suse.de>
	<20070720164635.GB459@agk.fab.redhat.com>
	<20070812162716.GA9108@bogon.ms20.nix>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20070812162716.GA9108@bogon.ms20.nix>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

On Sun, Aug 12, 2007 at 06:27:17PM +0200, Guido Guenther wrote:
> +		[state]       = "DM_STATE=\"%s%s\"\n",
> +		[tablestate]  = "DM_TABLE_STATE=\"%s%s%s\"\n",

Why use freetext fields if you can set it in a splitted way?

DM_STATE for example shows both suspended and read-only state without
making in properly parsable.

> +	const char** format = _switches[EXPORT_ARG] ? export_formatstrings 
> +	                                            : info_formatstrings;

const char *const *.

Export without a device name makes no sense.

Bastian

-- 
Landru! Guide us!
		-- A Beta 3-oid, "The Return of the Archons", stardate 3157.4
