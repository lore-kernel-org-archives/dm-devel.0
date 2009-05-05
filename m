From: "Bryn M. Reeves" <bmr@redhat.com>
Subject: Re: DM vs. MD: The showdown
Date: Tue, 05 May 2009 14:53:18 +0100
Message-ID: <1241531598.13505.32.camel@breeves.fab.redhat.com>
References: <4A00365B.7030500@stibo.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4A00365B.7030500@stibo.com>
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

On Tue, 2009-05-05 at 14:51 +0200, Flemming Frandsen wrote:
> For some reason dm has found it funny to grab the md1 and md2 mirrors 
> and use them to create the stripe set: /dev/mapper/md|md3

Have you installed/used EVMS on this system? It's the only application
that I am aware of that will create DM devices using this weird
<string>|<string> pattern.

Regards,
Bryn.
