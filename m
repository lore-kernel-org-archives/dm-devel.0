From: Sebastian Herbszt <herbszt@gmx.de>
Subject: Re: [PATCH 07/57] Add LIO-ORG/SUSE RBD backend hardware
 defaults
Date: Fri, 29 Apr 2016 00:32:57 +0200
Message-ID: <20160429003257.00000e22@localhost>
References: <1461755458-29225-1-git-send-email-hare@suse.de>
	<1461755458-29225-8-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1461755458-29225-8-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: dm-devel@redhat.com, Sebastian Herbszt <herbszt@gmx.de>, Mike Snitzer <snitzer@redhat.com>, Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

Hannes Reinecke wrote:
> The LIO-ORG RBD backend always supports ALUA, and should be assigned
> the correct values for multipathing.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  libmultipath/hwtable.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)

You missed adding it to multipath.conf.defaults.

Sebastian
