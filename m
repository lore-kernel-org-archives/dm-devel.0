From: Don Hoover <dxh@yahoo.com>
Subject: How about adding an include directive in multipath.conf
	file?
Date: Fri, 3 Dec 2010 13:18:38 -0800 (PST)
Message-ID: <583709.74205.qm@web120705.mail.ne1.yahoo.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
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

It sure would be nice to add an include directive to the multipath.conf file.


Almost all the stuff in there is defaults that you use for your entire environment and can be pushed out from a central configuration management system, but as soon as you want to add alias entries for a particular system it breaks this.

It sure is nice when daemons allow %includes in their configuration files for those of us that do centralized configuration management of our systems because you can then separate the common from the specific stuff.

I am looking at the config code now and what it would take to add a include keyword and process an additional config file, I might be able to work on a patch to accomplish this but, I thought maybe anyone who has worked on that code before might have a quick idea on how to accomplish this.
