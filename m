From: Peyrotau Yannick <peyrotau.yannick@free.fr>
Subject: Re: [PATCH] dm-striped device sizes must be multiple of
	chunk-size
Date: Tue, 30 May 2006 15:14:19 +0200
Message-ID: <447C452B.4030401@free.fr>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi, I have the same problem too when i try to upgrade to 2.6.16 kernel.

My motherbord is ASUS A8N-E with a nvidia raid chip.

I have make an archive with my metadata at this adress :
http://crashteam1.free.fr/metadata/metadata_isw-Yannick_Peyrotau-raid0.tar.bz2

Can i resolve it ?


Thanks,
Yannick

 > Dwaine,
 >
 > can you please send me your metadata for refernence as well so
 > that I can confirm that my fix is good for bz #186842 ?
 >
 > Thanks,
 > Heinz
 >
 > On Sun, Mar 26, 2006 at 12:01:17AM +0000, Dwaine Garden wrote:
 > > Kevin Corry <kevcorry <at> us.ibm.com> writes:
 > > >
 > > > I'm thinking that this mapping would do what the BIOS is actually
 > > > intending.
 > > > It ought to be relatively straight-forward to recognize this
 > > > situation in
 > > > dmraid and set up a mapping similar to the one above.
 > > >
 > >
 > > I have the same problem.  How would you resolve this?
 > >
 > > Dwaine
 > >
 > >
 > >
 > >
 > > --
 > > dm-devel mailing list
 > > dm-devel redhat com
 > > https://www.redhat.com/mailman/listinfo/dm-devel
