From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: [multipath-tools][PATCH] two small fixes
Date: Fri, 30 Sep 2005 17:57:47 +0200
Message-ID: <1128095868.6536.59.camel@zezette>
References: <OF487CD56F.3D816B45-ONC125708C.004DA374-C125708C.004E5ECD@de.ibm.com>
Reply-To: christophe.varoqui@free.fr,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <OF487CD56F.3D816B45-ONC125708C.004DA374-C125708C.004E5ECD@de.ibm.com>
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


> 
> For dmsetup status:
> 
> ess15-5320: 0 6835968 multipath 1 0 0 1 1 A 0 2 1 8:0 A 0 x 8:16 A 0 x
>                                                 ^
> 
> The 1 after the number of paths means the path selector will write 1 
> additional piece of information
> after the default output of each path. (e.g. <device> <state> <failcount> 
> <something>)
> The current code expects these data only once after all paths have been 
> written but it has to skip
> these data for every path. The round-robin slector doesn't use any data 
> per path so the current
> logic work but as soon as it is used you would fail to get the current 
> state.
> 
ok, thank you for the detailled answer.
I will apply the patch then.

Regards,
cvaroqui
