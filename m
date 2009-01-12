From: Ritesh Raj Sarraf <rrs@researchut.com>
Subject: dm-crypt low performance
Date: Tue, 13 Jan 2009 00:52:40 +0530
Message-ID: <0ths36-dce.ln1@news.researchut.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
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
Cc: dm-crypt@saout.de
List-Id: dm-devel.ids

Hi,

I'm using dm-crypt on an external USB enclosure ide hdd. I copied 20Gb of 
data on to the encrypted device and am suffering severe performance penalty.
After a couple of seconds, all processes involved in the I/O keep stalling. 
They periodically resume, just for a couple of seconds and then again stall.

Running linux 2.6.26.


Here's the state of the Blocked Tasks during the stall.


[15869.848387] SysRq : Show Blocked State                                                                             
[15869.848387]   task                PC stack   pid father                                                            
[15869.848387] dolphin       D 00000040     0  5823      1                                                            
[15869.848387]        f29d5ce0 00000086 01c4e000 00000040 c03c1430 c03c4740 
c03c4740 f29d5ce0                         
[15869.848387]        f29d5e6c c2012740 00000000 4dd0acd3 00000e43 f79b48d0 
f29d5e6c 00000000                         
[15869.848387]        8f000000 c0135b72 02f7dbd6 f3033158 02f7dbd6 f2855d40 
c2012740 c2012b44                         
[15869.848387] Call Trace:                                                                                            
[15869.848387]  [<c0135b72>] getnstimeofday+0x32/0xaf                                                                 
[15869.848387]  [<c02c1091>] io_schedule+0x4f/0x86                                                                    
[15869.848387]  [<c01954ff>] sync_buffer+0x30/0x33                                                                    
[15869.848387]  [<c02c14fc>] __wait_on_bit+0x33/0x58                                                                  
[15869.848387]  [<c01954cf>] sync_buffer+0x0/0x33                                                                     
[15869.848387]  [<c02c15d7>] out_of_line_wait_on_bit+0xb6/0xbe                                                        
[15869.848387]  [<c01954cf>] sync_buffer+0x0/0x33                                                                     
[15869.848387]  [<c0131437>] wake_bit_function+0x0/0x3c                                                               
[15869.848387]  [<c019547f>] __wait_on_buffer+0x16/0x18                                                               
[15869.848387]  [<f8bae022>] ext3_find_entry+0x36b/0x4fb [ext3]                                                       
[15869.848387]  [<c01888e8>] ifind_fast+0x34/0x63                                                                     
[15869.848387]  [<c01893d1>] iget_locked+0x2a/0x105                                                                   
[15869.848387]  [<f8ba95e9>] ext3_iget+0xc/0x317 [ext3]                                                               
[15869.848387]  [<f8bae8be>] ext3_lookup+0x21/0x9b [ext3]                                                             
[15869.848387]  [<c017e590>] do_lookup+0xb4/0x153                                                                     
[15869.848387]  [<c01802bf>] __link_path_walk+0x834/0xc65                                                             
[15869.848387]  [<c018b72e>] mntput_no_expire+0x18/0xf0                                                               
[15869.848387]  [<c0187e3c>] dput+0x34/0xe4                                                                           
[15869.848387]  [<c018073b>] path_walk+0x4b/0x99                                                                      
[15869.848387]  [<c0180a10>] do_path_lookup+0x186/0x1cf                                                               
[15869.848387]  [<c017fa39>] getname+0x5e/0xb0                                                                        
[15869.848387]  [<c01812ee>] __user_walk_fd+0x29/0x3a                                                                 
[15869.848387]  [<c017b2c7>] vfs_stat_fd+0x15/0x3c                                                                    
[15869.848387]  [<c0127bef>] cap_set_effective+0x10/0x38                                                              
[15869.848387]  [<c01775a7>] sys_faccessat+0x143/0x14d                                                                
[15869.848387]  [<c017b3a3>] sys_stat64+0xf/0x24                                                                      
[15869.848387]  [<c015078a>] audit_syscall_entry+0xf8/0x122                                                           
[15869.848387]  [<c0108f3f>] do_syscall_trace+0x12a/0x16e                                                             
[15869.848387]  [<c010398a>] syscall_call+0x7/0xb                                                                     
[15869.848387]  [<c02c0000>] cpu_callback+0x4f/0x12a                                                                  
[15869.848387]  =======================                                                                               
[15869.848387] usb-storage   D c2012740     0 13131      2                                                            
[15869.848387]        f29d54a0 00000046 01c4e000 c2012740 c03c1430 c03c4740 
c03c4740 f29d54a0                         
[15869.848387]        f29d562c c2012740 00000000 d998eb08 f8a5b12f f29d54a0 
f29d562c 00eb4d09                         
[15869.848387]        f73b6600 f1a50708 00000000 00000000 00000000 000000ff 
f30453d8 7fffffff                         
[15869.848387] Call Trace:                                                                                            
[15869.848387]  [<f8a5b12f>] usb_hcd_submit_urb+0x766/0x82c [usbcore]                                                 
[15869.848387]  [<c02c12d5>] schedule_timeout+0x14/0xbb                                                               
[15869.848387]  [<c02c12d5>] schedule_timeout+0x14/0xbb                                                               
[15869.848387]  [<c01337e5>] enqueue_hrtimer+0xbd/0xc7                                                                
[15869.848387]  [<c010797b>] nommu_map_sg+0x78/0x86                                                                   
[15869.848387]  [<c02c11e8>] wait_for_common+0xbc/0x11a                                                               
[15869.848387]  [<c011a40d>] default_wake_function+0x0/0x8                                                            
[15869.848387]  [<f8a5bd38>] usb_sg_wait+0xfd/0x10a [usbcore]                                                         
[15869.848387]  [<f911af39>] usb_stor_bulk_transfer_sglist+0x72/0xb0 
[usb_storage]                                    
[15869.848387]  [<f911afe3>] usb_stor_bulk_srb+0x18/0x28 [usb_storage]                                                
[15869.848387]  [<f911b0f5>] usb_stor_Bulk_transport+0x102/0x23d 
[usb_storage]                                        
[15869.848387]  [<f911ad22>] usb_stor_invoke_transport+0x15/0x1ba 
[usb_storage]                                       
[15869.848387]  [<c0118140>] hrtick_start_fair+0xe1/0x126                                                             
[15869.848387]  [<c02c1aa1>] __down_interruptible+0x61/0x97                                                           
[15869.848387]  [<f911c080>] usb_stor_control_thread+0x113/0x1af 
[usb_storage]                                        
[15869.848387]  [<c011a8cc>] complete+0x28/0x36                                                                       
[15869.848387]  [<f911bf6d>] usb_stor_control_thread+0x0/0x1af [usb_storage]                                          
[15869.848387]  [<c01311a6>] kthread+0x38/0x5d                                                                        
[15869.848387]  [<c013116e>] kthread+0x0/0x5d                                                                         
[15869.848387]  [<c01045af>] kernel_thread_helper+0x7/0x10                                                            
[15869.848387]  =======================                                                                               
[15869.848387] kcryptd       D f7044a0c     0 13656      2                                                            
[15869.848387]        f29d79c0 00000046 01c58000 f7044a0c c03c1430 c03c4740 
c03c4740 f29d79c0                         
[15869.848387]        f29d7b4c c201c740 00000001 00010001 00000001 f79b48d0 
f29d7b4c 00eb4b70                         
[15869.848387]        c01df9a6 c0135b72 00000000 00000000 00000000 000000ff 
c201c740 c201cb44                         
[15869.848387] Call Trace:                                                                                            
[15869.848387]  [<c01df9a6>] cfq_may_queue+0x48/0xab                                                                  
[15869.848387]  [<c0135b72>] getnstimeofday+0x32/0xaf                                                                 
[15869.848387]  [<c02c1091>] io_schedule+0x4f/0x86                                                                    
[15869.848387]  [<c01d734f>] get_request_wait+0xf2/0x16d                                                              
[15869.848387]  [<c013140a>] autoremove_wake_function+0x0/0x2d                                                        
[15869.848387]  [<c01d7789>] __make_request+0x2b7/0x33a                                                               
[15869.848387]  [<c01d6465>] generic_make_request+0x419/0x44a                                                         
[15869.848387]  [<f8c30563>] async_encrypt+0x2f/0x35 [crypto_blkcipher]                                               
[15869.848387]  [<f8c659ce>] crypt_convert+0x20e/0x240 [dm_crypt]                                                     
[15869.848387]  [<f8c65c5d>] kcryptd_crypt+0x25d/0x339 [dm_crypt]                                                     
[15869.848387]  [<f8c65a00>] kcryptd_crypt+0x0/0x339 [dm_crypt]                                                       
[15869.848387]  [<f8c65a00>] kcryptd_crypt+0x0/0x339 [dm_crypt]                                                       
[15869.848387]  [<c012e818>] run_workqueue+0x73/0xed                                                                  
[15869.848387]  [<c012e949>] worker_thread+0xb7/0xc3                                                                  
[15869.848387]  [<c013140a>] autoremove_wake_function+0x0/0x2d                                                        
[15869.848387]  [<c012e892>] worker_thread+0x0/0xc3                                                                   
[15869.848387]  [<c01311a6>] kthread+0x38/0x5d                                                                        
[15869.848387]  [<c013116e>] kthread+0x0/0x5d                                                                         
[15869.848387]  [<c01045af>] kernel_thread_helper+0x7/0x10                                                            
[15869.848387]  =======================                                                                               
[15869.848387] kjournald     D 00000000     0 13832      2                                                            
[15869.848387]        f29d7180 00000046 01c4e000 00000000 c03c1430 c03c4740 
c03c4740 f29d7180                         
[15869.848387]        f29d730c c2012740 00000000 00000008 c0194792 f79b48d0 
f29d730c 00eab469                         
[15869.848387]        87000000 c0135b72 00000000 00000000 00000000 000000ff 
c2012740 c2012b44                         
[15869.848387] Call Trace:                                                                                            
[15869.848387]  [<c0194792>] __find_get_block_slow+0xdf/0xe8                                                          
[15869.848387]  [<c0135b72>] getnstimeofday+0x32/0xaf                                                                 
[15869.848387]  [<c02c1091>] io_schedule+0x4f/0x86                                                                    
[15869.848387]  [<c01954ff>] sync_buffer+0x30/0x33                                                                    
[15869.848387]  [<c02c14fc>] __wait_on_bit+0x33/0x58                                                                  
[15869.848387]  [<c01954cf>] sync_buffer+0x0/0x33                                                                     
[15869.848387]  [<c02c15d7>] out_of_line_wait_on_bit+0xb6/0xbe                                                        
[15869.848387]  [<c01954cf>] sync_buffer+0x0/0x33                                                                     
[15869.848387]  [<c0131437>] wake_bit_function+0x0/0x3c                                                               
[15869.848387]  [<c019547f>] __wait_on_buffer+0x16/0x18                                                               
[15869.848387]  [<c01958a3>] sync_dirty_buffer+0x6b/0x9c                                                              
[15869.848387]  [<f8b78fd5>] journal_commit_transaction+0x8b8/0xbc3 [jbd]                                             
[15869.848387]  [<c013140a>] autoremove_wake_function+0x0/0x2d                                                        
[15869.848387]  [<f8b7b5d5>] kjournald+0xb2/0x1cd [jbd]                                                               
[15869.848387]  [<c013140a>] autoremove_wake_function+0x0/0x2d                                                        
[15869.848387]  [<f8b7b523>] kjournald+0x0/0x1cd [jbd]                                                                
[15869.848387]  [<c01311a6>] kthread+0x38/0x5d                                                                        
[15869.848387]  [<c013116e>] kthread+0x0/0x5d                                                                         
[15869.848387]  [<c01045af>] kernel_thread_helper+0x7/0x10                                                            
[15869.848387]  =======================                                                                               
[15869.848387] kio_file      D c0135b72     0 14078   5348                                                            
[15869.848387]        f114d8c0 00000082 01c4e000 c0135b72 c03c1430 c03c4740 
c03c4740 f114d8c0                         
[15869.848387]        f114da4c c2012740 00000000 00000000 c0134170 f79b48d0 
f114da4c 00eab183                         
[15869.848387]        9e000000 c0135b72 00000000 00000000 00000000 000000ff 
c2012740 c2012b44                         
[15869.848387] Call Trace:                                                                                            
[15869.848387]  [<c0135b72>] getnstimeofday+0x32/0xaf                                                                 
[15869.848387]  [<c0134170>] ktime_get+0xf/0x2b                                                                       
[15869.848387]  [<c0135b72>] getnstimeofday+0x32/0xaf                                                                 
[15869.848387]  [<c02c1091>] io_schedule+0x4f/0x86                                                                    
[15869.848387]  [<c01954ff>] sync_buffer+0x30/0x33                                                                    
[15869.848387]  [<c02c14fc>] __wait_on_bit+0x33/0x58                                                                  
[15869.848387]  [<c01954cf>] sync_buffer+0x0/0x33                                                                     
[15869.848387]  [<c02c15d7>] out_of_line_wait_on_bit+0xb6/0xbe                                                        
[15869.848387]  [<c01954cf>] sync_buffer+0x0/0x33                                                                     
[15869.848387]  [<c0131437>] wake_bit_function+0x0/0x3c                                                               
[15869.848387]  [<c019547f>] __wait_on_buffer+0x16/0x18                                                               
[15869.848387]  [<c0195558>] bh_submit_read+0x47/0x56                                                                 
[15869.848387]  [<f8ba66e1>] read_block_bitmap+0x6a/0x115 [ext3]                                                      
[15869.848387]  [<f8ba732c>] ext3_new_blocks+0x253/0x569 [ext3]                                                       
[15869.848387]  [<f8baac45>] ext3_get_blocks_handle+0x332/0x785 [ext3]                                                
[15869.848387]  [<c0194ac9>] __find_get_block+0x162/0x16c                                                             
[15869.848387]  [<f8bab137>] ext3_get_block+0x9f/0xd3 [ext3]                                                          
[15869.848387]  [<c0195ef8>] __block_prepare_write+0x16e/0x373                                                        
[15869.848387]  [<c0196245>] block_write_begin+0x6c/0xc3                                                              
[15869.848387]  [<f8bab098>] ext3_get_block+0x0/0xd3 [ext3]                                                           
[15869.848387]  [<f8baa814>] ext3_write_begin+0xc1/0x168 [ext3]                                                       
[15869.848387]  [<f8bab098>] ext3_get_block+0x0/0xd3 [ext3]                                                           
[15869.848387]  [<c015912d>] generic_file_buffered_write+0xfa/0x56a                                                   
[15869.848387]  [<c01d0753>] cap_inode_need_killpriv+0x25/0x35                                                        
[15869.848387]  [<c01bdcd1>] security_inode_need_killpriv+0xc/0xd                                                     
[15869.848387]  [<c0159b98>] __generic_file_aio_write_nolock+0x3fa/0x445                                              
[15869.848387]  [<c0116c36>] kunmap_atomic+0x58/0x89                                                                  
[15869.848387]  [<c018acfa>] mnt_want_write+0x1a/0x5e                                                                 
[15869.848387]  [<c018b649>] mnt_drop_write+0x1a/0xb2                                                                 
[15869.848387]  [<c015a194>] generic_file_aio_read+0x474/0x4fa                                                        
[15869.848387]  [<c0159c43>] generic_file_aio_write+0x60/0xb7                                                         
[15869.848387]  [<f8ba7f6c>] ext3_file_write+0x19/0x85 [ext3]                                                         
[15869.848387]  [<c017815d>] do_sync_write+0xc0/0x107                                                                 
[15869.848387]  [<c013140a>] autoremove_wake_function+0x0/0x2d                                                        
[15869.848387]  [<c0104420>] apic_timer_interrupt+0x28/0x30                                                           
[15869.848387]  [<c017809d>] do_sync_write+0x0/0x107                                                                  
[15869.848387]  [<c01789d9>] vfs_write+0x84/0x121                                                                     
[15869.848387]  [<c0178b0e>] sys_write+0x3c/0x63                                                                      
[15869.848387]  [<c010398a>] syscall_call+0x7/0xb                                                                     
[15869.848387]  [<c02c0000>] cpu_callback+0x4f/0x12a                                                                  
[15869.848387]  =======================                                                                               
[15869.848387] pdflush       D ce29f9c0     0 14381      2                                                            
[15869.848387]        ce29d8c0 00000046 01c4e000 ce29f9c0 c03c1430 c03c4740 
c03c4740 ce29d8c0                         
[15869.848387]        ce29da4c c2012740 00000000 3c2642f9 00000004 00000286 
ce29da4c 00eb4d15                         
[15869.848387]        ce29daf9 d98ffef8 00000000 00000000 00000000 000000ff 
00eb4d78 00eb4d78                         
[15869.848387] Call Trace:                                                                                            
[15869.848387]  [<c02c1360>] schedule_timeout+0x9f/0xbb                                                               
[15869.848387]  [<c0128f95>] process_timeout+0x0/0x5                                                                  
[15869.848387]  [<c02c135b>] schedule_timeout+0x9a/0xbb                                                               
[15869.848387]  [<c02c08d1>] io_schedule_timeout+0x54/0x90                                                            
[15869.848387]  [<c0162769>] congestion_wait+0x51/0x66                                                                
[15869.848387]  [<c013140a>] autoremove_wake_function+0x0/0x2d                                                        
[15869.848387]  [<c015e135>] background_writeout+0x9e/0xa8                                                            
[15869.848387]  [<c015e6e5>] pdflush+0x128/0x1c4                                                                      
[15869.848387]  [<c015e097>] background_writeout+0x0/0xa8                                                             
[15869.848387]  [<c015e5bd>] pdflush+0x0/0x1c4                                                                        
[15869.848387]  [<c01311a6>] kthread+0x38/0x5d                                                                        
[15869.848387]  [<c013116e>] kthread+0x0/0x5d                                                                         
[15869.848387]  [<c01045af>] kernel_thread_helper+0x7/0x10                                                            
[15869.848387]  =======================                                                                               
[15869.848387] pdflush       D c03572f4     0 14393      2                                                            
[15869.848387]        ce29f9c0 00000046 01c4e000 c03572f4 c03c1430 c03c4740 
c03c4740 ce29f9c0                         
[15869.848387]        ce29fb4c c2012740 00000000 424a07a6 00000e4c 00000286 
ce29fb4c da55bf00                         
[15869.848387]        ce29fbf9 da55bf00 00000286 c0129430 00eb4d78 00000286 
00eb4d78 00eb4d78                         
[15869.848387] Call Trace:                                                                                            
[15869.848387]  [<c0129430>] __mod_timer+0xba/0xc3                                                                    
[15869.848387]  [<c02c1360>] schedule_timeout+0x9f/0xbb                                                               
[15869.848387]  [<c0128f95>] process_timeout+0x0/0x5                                                                  
[15869.848387]  [<c02c135b>] schedule_timeout+0x9a/0xbb                                                               
[15869.848387]  [<c02c08d1>] io_schedule_timeout+0x54/0x90                                                            
[15869.848387]  [<c0162769>] congestion_wait+0x51/0x66                                                                
[15869.848387]  [<c013140a>] autoremove_wake_function+0x0/0x2d                                                        
[15869.848387]  [<c015dca7>] wb_kupdate+0x98/0xe0                                                                     
[15869.848387]  [<c015e6e5>] pdflush+0x128/0x1c4                                                                      
[15869.848387]  [<c015dc0f>] wb_kupdate+0x0/0xe0                                                                      
[15869.848387]  [<c015e5bd>] pdflush+0x0/0x1c4                                                                        
[15869.848387]  [<c01311a6>] kthread+0x38/0x5d                                                                        
[15869.848387]  [<c013116e>] kthread+0x0/0x5d                                                                         
[15869.848387]  [<c01045af>] kernel_thread_helper+0x7/0x10                                                            
[15869.848387]  =======================                                                                               
[15869.848387] Sched Debug Version: v0.07, 2.6.26-custom #1                                                           
[15869.848387] now at 15720716.621199 msecs                                                                           
[15869.848387]   .sysctl_sched_latency                    : 40.000000                                                 
[15869.848387]   .sysctl_sched_min_granularity            : 8.000000                                                  
[15869.848387]   .sysctl_sched_wakeup_granularity         : 20.000000                                                 
[15869.848387]   .sysctl_sched_child_runs_first           : 0.000001                                                  
[15869.848387]   .sysctl_sched_features                   : 895                                                       
[15869.848387]                                                                                                        
[15869.848387] cpu#0, 1997.378 MHz                                                                                    
[15869.848387]   .nr_running                    : 0                                                                   
[15869.848387]   .load                          : 0                                                                   
[15869.848387]   .nr_switches                   : 24816086                                                            
[15869.848387]   .nr_load_updates               : 9274614                                                             
[15869.848387]   .nr_uninterruptible            : 4294964470                                                          
[15869.848387]   .jiffies                       : 15420709                                                            
[15869.848387]   .next_balance                  : 15.420961                                                           
[15869.848387]   .curr->pid                     : 0                                                                   
[15869.848387]   .clock                         : 15720716.023917                                                     
[15869.848387]   .cpu_load[0]                   : 0                                                                   
[15869.848387]   .cpu_load[1]                   : 108                                                                 
[15869.848387]   .cpu_load[2]                   : 433                                                                 
[15869.848387]   .cpu_load[3]                   : 493                                                                 
[15869.848387]   .cpu_load[4]                   : 359                                                                 
[15869.848387]                                                                                                        
[15869.848387] cfs_rq[0]:                                                                                             
[15869.848387]   .exec_clock                    : 0.000000                                                            
[15869.848387]   .MIN_vruntime                  : 0.000001                                                            
[15869.848387]   .min_vruntime                  : 2414306.866666                                                      
[15869.848387]   .max_vruntime                  : 0.000001                                                            
[15869.848387]   .spread                        : 0.000000                                                            
[15869.848387]   .spread0                       : 0.000000                                                            
[15869.848387]   .nr_running                    : 0                                                                   
[15869.848387]   .load                          : 0                                                                   
[15869.848387]   .nr_spread_over                : 0                                                                   
[15869.848387]                                                                                                        
[15869.848387] runnable tasks:                                                                                        
[15869.848387]             task   PID         tree-key  switches  prio     
exec-runtime         sum-exec        sum-sleep                                                                                                                   
[15869.848387] 
----------------------------------------------------------------------------------------------------------                                                                                                                   
[15869.848387]                                                                                                        
[15869.848387] cpu#1, 1997.378 MHz                                                                                    
[15869.848387]   .nr_running                    : 3                                                                   
[15869.848387]   .load                          : 3072                                                                
[15869.848387]   .nr_switches                   : 22671295                                                            
[15869.848387]   .nr_load_updates               : 10377709                                                            
[15869.848387]   .nr_uninterruptible            : 2833                                                                
[15869.848387]   .jiffies                       : 15420709                                                            
[15869.848387]   .next_balance                  : 15.420960                                                           
[15869.848387]   .curr->pid                     : 14604                                                               
[15869.848387]   .clock                         : 15720710.258267                                                     
[15869.848387]   .cpu_load[0]                   : 1024                                                                
[15869.848387]   .cpu_load[1]                   : 1008                                                                
[15869.848387]   .cpu_load[2]                   : 844                                                                 
[15869.848387]   .cpu_load[3]                   : 657                                                                 
[15869.848387]   .cpu_load[4]                   : 766                                                                 
[15869.848387]                                                                                                        
[15869.848387] cfs_rq[1]:                                                                                             
[15869.848387]   .exec_clock                    : 0.000000                                                            
[15869.848387]   .MIN_vruntime                  : 1992615.065627
[15869.848387]   .min_vruntime                  : 1992655.065624
[15869.848387]   .max_vruntime                  : 1992653.011804
[15869.848387]   .spread                        : 37.946177
[15869.848387]   .spread0                       : -421651.801042
[15869.848387]   .nr_running                    : 3
[15869.848387]   .load                          : 3072
[15869.848387]   .nr_spread_over                : 0
[15869.848387]
[15869.848387] runnable tasks:
[15869.848387]             task   PID         tree-key  switches  prio     
exec-runtime         sum-exec        sum-sleep
[15869.848387] 
----------------------------------------------------------------------------------------------------------
[15869.848387]         rsyslogd  3557   1992615.065627        97   120               
0               0               0.000000               0.000000               
0.000000 /
[15869.848387]              top 14469   1992653.011804       579   120               
0               0               0.000000               0.000000               
0.000000 /
[15869.848387] R           bash 14604   1992615.169510       173   120               
0               0               0.000000               0.000000               
0.000000 /
[15869.848387]


Ritesh
-- 
If possible, Please CC me when replying. I'm not subscribed to the list.
