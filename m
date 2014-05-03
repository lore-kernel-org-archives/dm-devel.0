From: John Utz <John.Utz@wdc.com>
Subject: are there usage examples for
	dm_sm_metadata_{create|open}?
Date: Sat, 3 May 2014 02:24:48 +0000
Message-ID: <8A51900D08212F40B3DE22453052F6981D0EEE96@wdscexmb02>
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

Hi;

I am developing a simulator for ZBC/ZAC devices using the linear target source code as the starting point. I talked briefly with Ric Wheeler about this project at Napa so he may be in a position to provide you with more context than i am putting into this email.

Since this simulator is expected to be highly configurable i dont have the luxury of hardcoding anything important, so i am on the hunt for A Cunning Plan.

Specifically, I need to be able to configure the number and size of a series of equally sized subdivisions the linear space into discrete equally sized chunks and then *save* this information off somewhere for future use so that we know how to interpret the data that has been saved to the underlying device.

The needs for the simulator metadata are pretty simple; number of subdivisions, size of subdivisions, etc. They just need to persist beyond the lifetime of the module.

So, the stuff in persistent-data sure seems like a good candidate for getting the job done. :-)

It seems like the first basic action one would want to perform would be to create a metadata 'blob' and then at some point in the future one would regularly want to open said metadata blob. The dm_sm_metadata_create and open functions seem perfect for the job.

But for some reason, I am unable to find a place in the md directory where this is getting used.

I would have thought that dm-cache-metadata.c would be using it, but it doesnt seem to be thinking about this in the same way. It uses dm_block_manager_create() and __create_persistent_data_objects().

I have perused dm-cache-metadata.c and dm-thin-metadata.c and they seem significantly more ambitious than anything the simulator needs to do.

Can any of you folks provide me with some guidance or sample code to look at to get me bootstrapped toward getting this done?

tnx!

johnu
