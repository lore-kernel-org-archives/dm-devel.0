From: Michael =?ISO-8859-1?Q?La=DF?= <bevan@bi-co.net>
Subject: multipath-tools: enabling multipathd.service fails
Date: Sun, 12 Nov 2017 14:03:45 +0100
Message-ID: <1510491825.23506.9.camel@bi-co.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

Hi,

when running "systemctl enable multipathd.service", systemd also wants
to enable multipathd.socket due to the following line in
multipathd.service:

> [Install]
> ...
> Also=multipathd.socket

At least on systems running systemd 235, this leads to the following
error:

> The unit files have no installation config (WantedBy, RequiredBy, Also, Alias
> settings in the [Install] section, and DefaultInstance for template units).
> This means they are not meant to be enabled using systemctl.
> Possible reasons for having this kind of units are:
> 1) A unit may be statically enabled by being symlinked from another unit's
>    .wants/ or .requires/ directory.
> 2) A unit's purpose may be to act as a helper for some other unit which has
>    a requirement dependency on it.
> 3) A unit may be started when needed via activation (socket, path, timer,
>    D-Bus, udev, scripted systemctl call, ...).
> 4) In case of template units, the unit is meant to be enabled with some
>    instance name specified.

This error occurs because multipathd.socket is missing an [Install]
section and in particular a "WantedBy" line, so systemd does not know
how to enable it. The section was removed in commit
62ef3766d9472f2122bc1dbd1e685f3e914b626b a few years ago.

I guess there are two options to fix this: either removing the "Also"
line in multipathd.service so that multipathd.socket is not enabled as
well, or adding back an [Install] section to multipathd.socket.

Cheers,
Michael
