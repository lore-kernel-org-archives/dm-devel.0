From: "goggin, edward" <egoggin@emc.com>
Subject: concurrent invocations of multipath on same mapped device
Date: Wed, 30 Mar 2005 16:46:23 -0500
Message-ID: <C2EEB4E538D3DC48BF57F391F422779321A890@SRMANNING.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "'dm-devel@redhat.com'" <dm-devel@redhat.com>
Cc: 'Christophe Varoqui' <christophe.varoqui@free.fr>
List-Id: dm-devel.ids

On Tue, 29 Mar 2005 23:14:13 +0200
christophe varoqui <christophe.varoqui@free.fr> wrote
> That was the idea, yes.
> In early design, multipath was an all-or-nothing thing.
> 
> As it evolved to trim its scope to specific multipaths, I 
> thought it was
> not necessary to keep it from running in parralel on different
> multipaths.
> 
> I eyeballed the code and didn't see a justification to keep it running
> alone.
> 
> Did I miss something important there ?

Not sure.  I agree that servicing different maps in parallel is
a good thing to do ... but what keeps multiple invocations of
multipath from running concurrently on the same multipath mapped
device?  I think nothing does and in this case, I think there is
nothing that guarantees a time ordering of path related actions.
Not clear if this is a problem though. 
