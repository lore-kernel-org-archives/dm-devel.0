From: Domenico Viggiani <dviggiani@tiscali.it>
Subject: RE: [PATCH] Use 'mpatha' for user_friendly_names option
Date: Wed, 7 May 2008 08:37:56 +0200
Message-ID: <000001c8b00c$e26539c0$cf42e3c1@pitagora.it>
References: <20080430090329.CAC0718C6FF@pentland.suse.de>	<20080506193539.GA7332@bogon.ms20.nix>
	<482149EC.4080808@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <482149EC.4080808@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: 'device-mapper development' <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hannes Reinecke wrote:
>
> Normally I don't use this option much; in fact, I discourage 
> everyone on using it :-) I really loath to have external 
> configuration files to get your filesystem up.

In fact, I remember the nasty problem at boot time with bindings file
residing under /var/lib/multipath when this is a filesystem different from
/:
 http://kbase.redhat.com/faq/FAQ_96_12017.shtm

--
Domenico Viggiani
