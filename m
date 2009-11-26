From: malahal@us.ibm.com
Subject: Re: [PATCH 7/7] Hold all write bios when errors are handled
Date: Thu, 26 Nov 2009 14:22:28 -0800
Message-ID: <20091126222228.GA27430@us.ibm.com>
References: <Pine.LNX.4.64.0911180711510.21358@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0911180712340.21358@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0911180713150.21358@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0911180718540.21358@hs20-bc2-1.build.redhat.com>
	<20091123055835.GA28981@us.ibm.com>
	<Pine.LNX.4.64.0911240638250.27545@hs20-bc2-1.build.redhat.com>
	<20091124191704.GB7971@us.ibm.com>
	<Pine.LNX.4.64.0911250807500.14481@hs20-bc2-1.build.redhat.com>
	<20091125202346.GB1673@us.ibm.com>
	<Pine.LNX.4.64.0911261256270.28831@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0911261256270.28831@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

Mikulas Patocka [mpatocka@redhat.com] wrote:
> > > If you ask the admin always if primary leg failed and wait for his
> > > action, you lose fault-tolerance --- the computer would wait until
> > > the admin does an action.
> > 
> > Well, we are talking one time admin help at reboot [actually activation
> > time] if and only if the "state of the mirror" changed during reboot!
> > This is not applicable at run time. Most of the time, dmeventd will have
> > a chance to change the mirror to linear anyway.
> 
> You can ask the admin about failed on reboot --- but why do it if it can 
> continue on its own? (unless both legs fail)

Agreed, it is better to stop on either failure.
