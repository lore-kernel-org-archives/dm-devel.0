From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH] 11-dm-mpath.rules: Fix udev rule processing
 during coldplug
Date: Mon, 29 Jun 2020 22:33:20 +0200
Message-ID: <1dc69f7925f577d3cee015d80b130ffae8433d5f.camel@suse.com>
References: <20200602155443.14072-1-mwilck@suse.com>
	<20200602212121.GA3266@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200602212121.GA3266@octiron.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi Ben, Hi Christophe,

On Tue, 2020-06-02 at 16:21 -0500, Benjamin Marzinski wrote:
> On Tue, Jun 02, 2020 at 05:54:43PM +0200, mwilck@suse.com wrote:
> > From: Martin Wilck <mwilck@suse.com>
> > 
> > DM_SUBSYSTEM_UDEV_FLAG0 is used to indicate that upper layer
> > udev rules don't need to be processed for multipath maps, e.g.
> > for map reloads.
> > 
> > However, this can fail if maps were created during initrd
> > processing,
> > but udev processing for the change events of these maps didn't
> > complete because udevd was killed to switch root. So, in the
> > coldplug
> > case, play safe and process the rules once more.
> > 
> > Signed-off-by: Martin Wilck <mwilck@suse.com>
> Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

This patch was wrong. It doesn't hurt but it also doesn't help; it
simply has no effect because DM_SUBSYSTEM_UDEV_FLAG0
is never set on "add" uevents.

Christophe, please don't apply it.

Martin
