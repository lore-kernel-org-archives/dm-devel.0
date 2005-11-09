From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: improved daemon setup
Date: Wed, 09 Nov 2005 23:50:55 +0100
Message-ID: <1131576656.7463.59.camel@zezette>
References: <20051109220015.GD26529@phlogiston.msp.redhat.com>
Reply-To: christophe.varoqui@free.fr,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20051109220015.GD26529@phlogiston.msp.redhat.com>
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

On mer, 2005-11-09 at 16:00 -0600, Benjamin Marzinski wrote:
> If you log into a machine and start the multipathd daemon, you will hang on
> logout, because multipathd doesn't fully detach itself from the calling
> processes. Also, occasionally the device mapper library functions will print
> error messages to stdout.  These appear in the terminal that was used to
> start multipathd, if it was started by hand (not by init scripts).  To fix these
> I added some code to fully daemonize multipathd, and redirect stdout and
> stderr to /dev/console.
> --
Thanks, applied.

BTW, Ed has to add a EMC copyright notice in multipathd/main.c
So I seeded the header with my copyright.
You can send a patch adding yours or Redhat's too ...

Regards,
cvaroqui
