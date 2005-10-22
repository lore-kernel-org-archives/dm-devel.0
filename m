From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: User friendly names patch.
Date: Sat, 22 Oct 2005 09:52:04 +0200
Message-ID: <1129967524.7313.65.camel@zezette>
References: <20051021233521.GA32160@phlogiston.msp.redhat.com>
Reply-To: christophe.varoqui@free.fr,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20051021233521.GA32160@phlogiston.msp.redhat.com>
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

On ven, 2005-10-21 at 18:35 -0500, Benjamin Marzinski wrote:
> This is a patch to add the option of more user friendly names for the
> multipath maps, in the form of mpath<n>.  It adds a configuration option
> "user_friendly_names". If set, it will cause multipath to check a bindings
> file for the names. The bindings file (/var/lib/multipath/bindings) has
> alias to wwid mappings. If multipath finds its wwid in the file, it uses
> the associated alias. If not, it creates a new alias, and adds the binding
> to the bindings file. If the config option is not set, multipath defaults
> to it's regular behavior. Specific aliases in /etc/multipath.conf override
> this behavior.
> 
On eof my worry is that /var/lib/multipath/bindings is not available in
early userspace. Is this taken care of. Also remember not relying on
hotplug to execute multipath in early userspace is a redhat choice.
Others strategy may differ.

Regards,
cvaroqui
