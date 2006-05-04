From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: Setting up a multipath device
Date: Thu, 04 May 2006 20:55:27 +0200
Message-ID: <1146768927.27764.12.camel@localhost.localdomain>
References: <445A0AE9.20907@voltaire.com> <20060504144915.GA2319@pundit>
	<445A1D88.7030500@voltaire.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <445A1D88.7030500@voltaire.com>
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
>    1. Was it wrong to run 'multipath 2 round-robin 1 0 /dev/sda
>       round-robin 1 0 /dev/sdb'?

The multipath command just don't understand these parameters.
This is a map as seen by the DM kernel driver. You can feed it to
dmsetup(8), not to multipath(8).

>    2. If I don't supply any parameters, how does the dm know which
>       devices are the same physical device (that /dev/sda & /dev/sdb are
>       the same physical device)?

Because it scans the paths for unique LU ids, then coalesce.

>    3. How are the priority groups defined if no parameters are supplied?

User defines, through config file.

>    4. What is the timeout for a device that has failed? When does the dm
>       move to the next priority group?
> 
When secondary PG priority becomes higher than the active PG priority,
modulo user-define delay or user-define disabling.

Or when all paths in the active PG have failed.

Regards,
cvaroqui
