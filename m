From: John Utz <John.Utz@wdc.com>
Subject: Can device mapper be taught to return new errors and
 sense codes that are part of the ZAC/ZBC spec?
Date: Sat, 3 May 2014 02:40:51 +0000
Message-ID: <8A51900D08212F40B3DE22453052F6981D0EEEA9@wdscexmb02>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi again;

This question is also related to the same simulator project mentioned in my previous email.

The ZAC/ZBC spec(s) specify some errors that dont currently exist. For the simulator to be successful, it needs to be able to respond appropriately to being asked to do things that other drives are allowed to do, but this one is not.

So read's and writes for the simulator have to return errors that dont currently exist in the kernel as of today.

I notice that struct dm_target has an error string entry, but that is only for the ctor and it's a string.

Can any of you provide any suggestions of guidance on this topic?

tnx!

johnu
