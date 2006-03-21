From: Brad Johnson <bjohnson@proficientsolutionsinc.com>
Subject: RE: path selector question
Date: Tue, 21 Mar 2006 10:43:31 -0600
Message-ID: <1142959411.3824.15.camel@homer>
References: <C2EEB4E538D3DC48BF57F391F422779321B135@SRMANNING.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <C2EEB4E538D3DC48BF57F391F422779321B135@SRMANNING.eng.emc.com>
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

See, I knew it was something simple. It's just a matter of naming the
module exactly the same as what is in the configuration file.

Thank you very much.
Regards,
Brad Johnson

On Tue, 2006-03-21 at 11:15 -0500, egoggin@emc.com wrote:
> The path selector and hardware handler dm-multipath modules
> are loaded using module automatic loading enabled by the
> kernel's "CONFIG_KMOD" define.  Check out the calls
> to request_module from both dm_get_path_selector and
> dm_get_hw_handler respectively.
> 
> > -----Original Message-----
> > From: dm-devel-bounces@redhat.com 
> > [mailto:dm-devel-bounces@redhat.com] On Behalf Of Brad Johnson
> > Sent: Tuesday, March 21, 2006 10:41 AM
> > To: dm-devel@redhat.com
> > Subject: [dm-devel] path selector question
> > 
> > I am in the process of adding one or more new path selector 
> > types to the
> > device-mapper. While the dm-round-robin module gets 
> > automatically loaded
> > when multipath is started, my new module does not (I have to manually
> > add it with modprobe). I know there are many ways I can have this done
> > automatically, such as adding my own init script. But I am 
> > very curious
> > how the round-robin module is getting automatically loaded. I have
> > grepped through all the source code for multipath-tools and device-
> > mapper, as well as the config files for the tools. And while 
> > it might be
> > obvious how this is happening, I can't see it.
> > Any help with this will be appreciated.
> > 
> > Thanks,
> > Brad Johnson
> > 
> > 
> > --
> > dm-devel mailing list
> > dm-devel@redhat.com
> > https://www.redhat.com/mailman/listinfo/dm-devel
> > 
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
> 
