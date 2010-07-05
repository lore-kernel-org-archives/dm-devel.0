From: Christophe Varoqui <christophe.varoqui@gmail.com>
Subject: Re: understanding of multipathing and speed
Date: Mon, 05 Jul 2010 20:58:30 +0200
Message-ID: <1278356310.30539.606.camel@localhost>
References: <201007052037.39362.bart.coninckx@telenet.be>
Reply-To: christophe.varoqui@opensvc.com,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <201007052037.39362.bart.coninckx@telenet.be>
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

On lun., 2010-07-05 at 20:37 +0200, Bart Coninckx wrote:
> Hi,
> 
> I would like to run my ideas by this list about multipathing and the results 
> as far as storage speed is concerned.
> 
> I'm using multipathing to two iSCSI targets pointing to the same storage. It 
> was my understanding that this provides for network path redundancy (and it 
> does, I tested this) but also for added speed. 
> I did some tests with Bonnie++ however while both paths were active and one 
> path was down and the results are basically the same. 
> 
> Am I assuming wrong things? Or have I configured things wrong?
> 
can you also include a 'multipath -l' output and sketch the
hba/switch/controller physical connections ?

thanks,
-- 
Christophe Varoqui <christophe.varoqui@opensvc.com>
OpenSVC
