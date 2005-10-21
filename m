From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: User friendly names patch.
Date: Fri, 21 Oct 2005 18:35:21 -0500
Message-ID: <20051021233521.GA32160@phlogiston.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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

This is a patch to add the option of more user friendly names for the
multipath maps, in the form of mpath<n>.  It adds a configuration option
"user_friendly_names". If set, it will cause multipath to check a bindings
file for the names. The bindings file (/var/lib/multipath/bindings) has
alias to wwid mappings. If multipath finds its wwid in the file, it uses
the associated alias. If not, it creates a new alias, and adds the binding
to the bindings file. If the config option is not set, multipath defaults
to it's regular behavior. Specific aliases in /etc/multipath.conf override
this behavior.

-Ben
