From: John Brier <jbrier@redhat.com>
Subject: Re: Question regarding failback option in multipath.conf
Date: Wed, 30 Sep 2009 15:24:52 -0400
Message-ID: <4AC3B084.4060700@redhat.com>
References: <5A70833B-9208-470E-88B7-7C351EED2122@aclue.com>	<4AC3AC88.9020404@redhat.com>
	<06F122DE-B7E5-4721-BA08-D0453D10581C@aclue.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <06F122DE-B7E5-4721-BA08-D0453D10581C@aclue.com>
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

On 09/30/2009 03:16 PM, Eli Klein wrote:
>
> Here's the abbreviated output from multipath -v3:
>
> mpath1: pgfailback = 120 (config file default)
> mpath1: pgpolicy = multibus (config file default)
> mpath1: selector = round-robin 0 (internal default)
> mpath1: features = 1 queue_if_no_path (internal default)
> mpath1: hwhandler = 0 (internal default)
> mpath1: rr_weight = 2 (config file default)
> mpath1: minio = 10 (config file default)
> mpath1: no_path_retry = 1 (config file default)
> pg_timeout = NONE (internal default)
> mpath1: set ACT_NOTHING (map unchanged)
>
> It's definitely picking up the settings correctly from multipath.conf,
> but the paths are still reinstated immediately once they're reconnected
> (even if it's just for a split second).
>

What does /var/log/messages look like when this happens? Since you 
changed failback to 120 did you restart multipathd or restart the box?

John Brier
