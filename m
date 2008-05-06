From: Guido =?iso-8859-1?Q?G=FCnther?= <agx@sigxcpu.org>
Subject: Re: [PATCH] Use 'mpatha' for user_friendly_names option
Date: Tue, 6 May 2008 21:35:39 +0200
Message-ID: <20080506193539.GA7332@bogon.ms20.nix>
References: <20080430090329.CAC0718C6FF@pentland.suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20080430090329.CAC0718C6FF@pentland.suse.de>
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

On Wed, Apr 30, 2008 at 11:03:29AM +0200, Hannes Reinecke wrote:
> 
> We really should use 'mpatha' instead of 'mpath0' for the
> generated names with the user_friendly_names option.
> Otherwise we can't distinguish them from EVMS names.

Is this really such a good idea? We shipped at least two upstream
versions with this user friendly names default. Changing this causes
problems and at least debian installer uses this during the installation
phase.
Wouldn't it be nicer to make the user_friendly_names_prefix configurable
so people can choose mpath, npath, mp or whatever they want leaving
mpath as the default? I can cook up a patch in that case.
Cheers,
 -- Guido
