From: christophe.varoqui@free.fr
Subject: Re: Question regarding multipath WWID
Date: Mon, 15 Jun 2009 23:07:41 +0200 (CEST)
Message-ID: <943776824.2607981245100061920.JavaMail.root@zimbra16-e3.priv.proxad.net>
References: <220888.26799.qm@web32002.mail.mud.yahoo.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <220888.26799.qm@web32002.mail.mud.yahoo.com>
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


> when I am using "user_friendly_names" in multipath configuraiton,
> without using any 'alias', I am getting the "bindings'  file
> after executing 'multipath'.  But  when I am using "alias" in
> the configuration file, the bindings file is not being generated.
> Though in the man page says  "alias" will update the "multipath" names.  
>
The bindings file is a place to store dynamically assigned names to
discovered multipaths. As a machine-handled file, it's place is in /var.
Whereas alias given names explicitely chosen by an admin, put in the
multipath config file ... in /etc.

Different role, different location. Just choose whatever fits your need
best. Cluster users tend to prefer controlling names across nodes, others
may prefer auto-assigned friendly names.

Regards,
cvaroqui
