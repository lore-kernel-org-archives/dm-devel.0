From: christophe varoqui <christophe.varoqui@free.fr>
Subject: Re: devmap_name replacement
Date: Tue, 29 Mar 2005 22:38:47 +0200
Message-ID: <1112128727.10635.25.camel@zezette>
References: <20050329192928.GD19749@agk.surrey.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20050329192928.GD19749@agk.surrey.redhat.com>
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

What about klibc build ?

I thought about that move a while back, and asked you about this
capability in dmsetup, but I steped back as people building for klibc
would have an additional burden.

Do you have a suggestion there ?
Do you think klibc building is overkill, and should be removed ?

Regards,
cvaroqui

On mar, 2005-03-29 at 20:29 +0100, Alasdair G Kergon wrote:
> No need for devmap_name as of device-mapper 1.01.01:
>   dmsetup -C --noheadings -o name -j major -m minor info
> 
> Or if you invoke dmsetup as devmap_name (e.g. symlink)
> it'll accept the devmap_name syntax:
>   devmap_name major minor
>   devmap_name major:minor
> 
> Alasdair
-- 
christophe varoqui <christophe.varoqui@free.fr>
