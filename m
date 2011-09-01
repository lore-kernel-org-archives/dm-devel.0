From: Christophe Varoqui <christophe.varoqui@gmail.com>
Subject: Re: [PATCH] multipath: systemd unit file
Date: Thu, 01 Sep 2011 09:04:31 +0200
Message-ID: <1314860671.14056.83.camel@lapoo.opensvc.com>
References: <20110901030028.GE11793@ether.msp.redhat.com>
	<4E5F24DE.50004@suse.de>
Reply-To: christophe.varoqui@opensvc.com,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4E5F24DE.50004@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

> > +[Unit]
> > +Description=Device-Mapper Multipath Device Controller
> > +Before=iscsi.service iscsid.service
> > +After=syslog.target
> > +
> > +[Service]
> > +Type=forking
> > +PIDFile=/var/run/multipathd.pid
> > +ExecStart=/sbin/multipathd
> > +ExecReload=/bin/kill -HUP $MAINPID
> > +#ExecStop=/path/to/scrip delete-me if not necessary
> > +
> > +[Install]
> > +WantedBy=multi-user.target
> >
> Hmm. First of all, I'm trying to get rid of the PID file, as with it 
> it's quite hard to start multipathing when /var/run isn't mounted.
> Plus it's not actually needed; everything can be done via multipathd 
> -k nowadays.
> 
Agreed

> So may I suggest to use
> ExecReload=/sbin/multipathd -k'reconfigure'
> 
Or even:
ExecReload=multipathd reconfigure

Regards,
-- 
Christophe Varoqui
OpenSVC - Tools to scale
http://www.opensvc.com/
